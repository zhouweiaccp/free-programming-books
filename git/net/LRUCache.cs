using System.Collections.Generic;
using System.Threading;
using System;
using System.Linq;
using System.Threading.Tasks;
//https://github.com/duyanming/Anno.LRUCache/blob/master/Anno.LRUCache/LRUCache.cs
namespace Anno.LRUCache
{
    /// <summary>
    /// 默认缓存长度255 五秒检查一次 30分钟未访问的 销毁
    /// 超过总长度的会被销毁，超时未访问的也销毁
    /// </summary>
    /// <typeparam name="TKey"></typeparam>
    /// <typeparam name="TValue"></typeparam>
    public class LRUCache<TKey, TValue> : IDisposable
    {
        private bool disposed;
        private CancellationTokenSource cancelToken;
        const int DEFAULT_CAPACITY = 255;

        int _capacity;
        double _seconds = 60 * 30;//30分钟
        ReaderWriterLockSlim _locker;
        IDictionary<TKey, TValue> _dictionary;
        /// <summary>
        /// Key 最后访问时间
        /// </summary>
        IDictionary<TKey, DateTime> _keyLastVisitTimeDictionary;
        /// <summary>
        /// Key 链表
        /// </summary>
        public LinkedList<TKey> _linkedList;
        public LRUCache() : this(DEFAULT_CAPACITY) { }
        ~LRUCache()
        {
            Dispose(false);
        }

        public LRUCache(int capacity)
        {
            _locker = new ReaderWriterLockSlim();
            _capacity = capacity > 0 ? capacity : DEFAULT_CAPACITY;
            _dictionary = new Dictionary<TKey, TValue>();
            _keyLastVisitTimeDictionary = new Dictionary<TKey, DateTime>();
            _linkedList = new LinkedList<TKey>();
            cancelToken = new CancellationTokenSource();
            Expire();
        }
        public LRUCache(int capacity, double expireSeconds) : this(capacity)
        {
            if (expireSeconds > 0)
            {
                _seconds = expireSeconds;
            }
        }

        public void Set(TKey key, TValue value)
        {
            _locker.EnterWriteLock();
            try
            {
                _dictionary[key] = value;
                _keyLastVisitTimeDictionary[key] = DateTime.Now;
                _linkedList.Remove(key);
                _linkedList.AddFirst(key);
                if (_linkedList.Count > _capacity)
                {
                    _dictionary.Remove(_linkedList.Last.Value);
                    _keyLastVisitTimeDictionary.Remove(_linkedList.Last.Value);
                    _linkedList.RemoveLast();
                }
            }
            finally { _locker.ExitWriteLock(); }
        }
        /// <summary>
        /// 获取Value 自定义是否延长 有效期
        /// </summary>
        /// <param name="key"></param>
        /// <param name="value"></param>
        /// <param name="isupdate">true  延长有效期; false 不延长有效期</param>
        /// <returns></returns>
        public bool TryGet(TKey key, out TValue value, bool isupdate)
        {
            _locker.EnterUpgradeableReadLock();
            try
            {
                bool b = _dictionary.TryGetValue(key, out value);
                if (b)
                {
                    _locker.EnterWriteLock();
                    try
                    {
                        if (isupdate)
                        {
                            _keyLastVisitTimeDictionary[key] = DateTime.Now;
                        }
                        _linkedList.Remove(key);
                        _linkedList.AddFirst(key);
                    }
                    finally { _locker.ExitWriteLock(); }
                }
                return b;
            }
            catch { throw; }
            finally { _locker.ExitUpgradeableReadLock(); }
        }
        /// <summary>
        /// 获取Value 并延长 有效期
        /// </summary>
        /// <param name="key"></param>
        /// <param name="value"></param>
        /// <returns></returns>
        public bool TryGet(TKey key, out TValue value)
        {
            var rlt = TryGet(key, out TValue tvalue, true);
            value = tvalue;
            return rlt;
        }
        /// <summary>
        /// 根据指定Key 移除 缓存
        /// </summary>
        /// <param name="key"></param>
        public void Remove(TKey key)
        {
            _locker.EnterWriteLock();
            try
            {
                _dictionary.Remove(key);
                _keyLastVisitTimeDictionary.Remove(key);
                _linkedList.Remove(key);
            }
            finally
            {
                _locker.ExitWriteLock();
            }
        }
        public bool ContainsKey(TKey key)
        {
            _locker.EnterReadLock();
            try
            {
                return _dictionary.ContainsKey(key);
            }
            finally { _locker.ExitReadLock(); }
        }

        public int Count
        {
            get
            {
                _locker.EnterReadLock();
                try
                {
                    return _dictionary.Count;
                }
                finally { _locker.ExitReadLock(); }
            }
        }

        public int Capacity
        {
            get
            {
                _locker.EnterReadLock();
                try
                {
                    return _capacity;
                }
                finally { _locker.ExitReadLock(); }
            }
            set
            {
                _locker.EnterUpgradeableReadLock();
                try
                {
                    if (value > 0 && _capacity != value)
                    {
                        _locker.EnterWriteLock();
                        try
                        {
                            _capacity = value;
                            while (_linkedList.Count > _capacity)
                            {
                                _linkedList.RemoveLast();
                            }
                        }
                        finally { _locker.ExitWriteLock(); }
                    }
                }
                finally { _locker.ExitUpgradeableReadLock(); }
            }
        }

        public ICollection<TKey> Keys
        {
            get
            {
                _locker.EnterReadLock();
                try
                {
                    return _dictionary.Keys;
                }
                finally { _locker.ExitReadLock(); }
            }
        }

        public ICollection<TValue> Values
        {
            get
            {
                _locker.EnterReadLock();
                try
                {
                    return _dictionary.Values;
                }
                finally { _locker.ExitReadLock(); }
            }
        }

        private void Expire()
        {
            Task.Factory.StartNew(() =>
            {
            Expire:
                try
                {
                    while (cancelToken.Token.IsCancellationRequested == false)
                    {
                        _locker.EnterReadLock();
                        var keys = _keyLastVisitTimeDictionary.Keys.ToList();
                        _locker.ExitReadLock();
                        var now = DateTime.Now;
                        foreach (var key in keys)
                        {
                            _keyLastVisitTimeDictionary.TryGetValue(key, out DateTime dateTime);
                            if (dateTime != null && (now - dateTime).TotalSeconds > _seconds)
                            {
                                Remove(key);

                            }
                        }
                        Thread.Sleep(5000);
                    }
                }
                catch
                {
                    _locker.ExitReadLock();
                    goto Expire;
                }
            }, cancelToken.Token);
        }

        private void Dispose(bool disposing)
        {
            if (!disposed)
            {
                if (disposing)
                {
                    cancelToken.Cancel();
                }
                disposed = true;
            }
        }
        public void Dispose()
        {
            Dispose(true);
            GC.SuppressFinalize(this);
        }
    }
}


//https://github.com/tejacques/LRUCache/blob/master/src/LRUCache/LRUCache.cs
//https://gitee.com/heng32032/LRUCache/blob/master/src/LRUCache/LRUCache.cs
using System;
using System.Collections;
using System.Collections.Generic;
using System.Runtime.CompilerServices;
using System.Text;
using System.Threading;

namespace Caching
{
    /// <summary>
    /// An LRU Cache implementation.
    /// </summary>
    /// <typeparam name="K">The key type.</typeparam>
    /// <typeparam name="V">The value type.</typeparam>
    public class LRUCache<K, V>
    {
        private readonly Dictionary<K, CacheNode> _entries;
        private readonly int _capacity;
        private CacheNode _head;
        private CacheNode _tail;
        private TimeSpan _ttl;
        private Timer _timer;
        private int _count;
        private bool _refreshEntries;

        /// <summary>
        /// A least recently used cache with a time to live.
        /// </summary>
        /// <param name="capacity">
        /// The number of entries the cache will hold
        /// </param>
        /// <param name="hours">The number of hours in the TTL</param>
        /// <param name="minutes">The number of minutes in the TTL</param>
        /// <param name="seconds">The number of seconds in the TTL</param>
        /// <param name="refreshEntries">
        /// Whether the TTL should be refreshed upon retrieval
        /// </param>
        public LRUCache(
            int capacity,
            int hours = 0,
            int minutes = 0,
            int seconds = 0,
            bool refreshEntries = true)
        {
            this._capacity = capacity;
            this._entries = new Dictionary<K, CacheNode>(this._capacity);
            this._head = null;
            this._tail = null;
            this._count = 0;
            this._ttl = new TimeSpan(hours, minutes, seconds);
            this._refreshEntries = refreshEntries;
            if (this._ttl > TimeSpan.Zero)
            {
                this._timer = new Timer(
                    Purge,
                    null,
                    (int)this._ttl.TotalMilliseconds,
                    5000); // 5 seconds
            }
        }

        private class CacheNode
        {
            public CacheNode Next { get; set; }
            public CacheNode Prev { get; set; }
            public K Key { get; set; }
            public V Value { get; set; }
            public DateTime LastAccessed { get; set; }
        }

        /// <summary>
        /// Gets the current number of entries in the cache.
        /// </summary>
        public int Count
        {
            get { return _entries.Count; }
        }

        /// <summary>
        /// Gets the maximum number of entries in the cache.
        /// </summary>
        public int Capacity
        {
            get { return this._capacity; }
        }

        /// <summary>
        /// Gets whether or not the cache is full.
        /// </summary>
        public bool IsFull
        {
            get { return this._count == this._capacity; }
        }

        /// <summary>
        /// Gets the item being stored.
        /// </summary>
        /// <returns>The cached value at the given key.</returns>
        public bool TryGetValue(K key, out V value)
        {
            CacheNode entry;
            value = default(V);

            if (!this._entries.TryGetValue(key, out entry))
            {
                return false;
            }

            if (this._refreshEntries)
            {
                MoveToHead(entry);
            }

            lock (entry)
            {
                value = entry.Value;
            }

            return true;
        }

        /// <summary>
        /// Sets the item being stored to the supplied value.
        /// </summary>
        /// <param name="key">The cache key.</param>
        /// <param name="value">The value to set in the cache.</param>
        public void Add(K key, V value)
        {
            TryAdd(key, value);
        }

        /// <summary>
        /// Sets the item being stored to the supplied value.
        /// </summary>
        /// <param name="key">The cache key.</param>
        /// <param name="value">The value to set in the cache.</param>
        /// <returns>True if the set was successful. False otherwise.</returns>
        public bool TryAdd(K key, V value)
        {
            CacheNode entry;
            if (!this._entries.TryGetValue(key, out entry))
            {
                // Add the entry
                lock (this)
                {
                    if (!this._entries.TryGetValue(key, out entry))
                    {
                        if (this.IsFull)
                        {
                            // Re-use the CacheNode entry
                            entry = this._tail;
                            _entries.Remove(this._tail.Key);

                            // Reset with new values
                            entry.Key = key;
                            entry.Value = value;
                            entry.LastAccessed = DateTime.UtcNow;

                            // Next and Prev don't need to be reset.
                            // Move to front will do the right thing.
                        }
                        else
                        {
                            this._count++;
                            entry = new CacheNode()
                            {
                                Key = key,
                                Value = value,
                                LastAccessed = DateTime.UtcNow
                            };
                        }
                        _entries.Add(key, entry);
                    }
                }
            }
            else
            {
                // If V is a nonprimitive Value type (struct) then sets are
                // not atomic, therefore we need to lock on the entry.
                lock (entry)
                {
                    entry.Value = value;
                }
            }

            MoveToHead(entry);

            // We don't need to lock here because two threads at this point
            // can both happily perform this check and set, since they are
            // both atomic.
            if (null == this._tail)
            {
                this._tail = this._head;
            }

            return true;
        }

        /// <summary>
        /// Removes the stored data.
        /// </summary>
        /// <returns>True if the removal was successful. False otherwise.</returns>
        public bool Clear()
        {
            lock (this)
            {
                this._entries.Clear();
                this._head = null;
                this._tail = null;
                return true;
            }
        }

        /// <summary>
        /// Moved the provided entry to the head of the list.
        /// </summary>
        /// <param name="entry">The CacheNode entry to move up.</param>
        private void MoveToHead(CacheNode entry)
        {
            if (entry == this._head)
            {
                return;
            }

            // We need to lock here because we're modifying the entry
            // which is not thread safe by itself.
            lock (this)
            {
                RemoveFromLL(entry);
                AddToHead(entry);
            }
        }

        private void Purge(object state)
        {
            if (this._ttl <= TimeSpan.Zero || this._count == 0)
            {
                return;
            }

            lock (this)
            {
                var current = this._tail;
                var now = DateTime.UtcNow;

                while (null != current
                    && (now - current.LastAccessed) > this._ttl)
                {
                    Remove(current);
                    // Going backwards
                    current = current.Prev;
                }
            }
        }

        private void AddToHead(CacheNode entry)
        {
            entry.Prev = null;
            entry.Next = this._head;

            if (null != this._head)
            {
                this._head.Prev = entry;
            }

            this._head = entry;
        }

        private void RemoveFromLL(CacheNode entry)
        {
            var next = entry.Next;
            var prev = entry.Prev;

            if (null != next)
            {
                next.Prev = entry.Prev;
            }
            if (null != prev)
            {
                prev.Next = entry.Next;
            }

            if (this._head == entry)
            {
                this._head = next;
            }

            if (this._tail == entry)
            {
                this._tail = prev;
            }
        }

        private void Remove(CacheNode entry)
        {
            // Only to be called while locked from Purge
            RemoveFromLL(entry);
            _entries.Remove(entry.Key);
            this._count--;
        }
    }
}