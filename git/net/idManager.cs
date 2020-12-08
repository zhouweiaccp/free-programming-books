using System.Threading;

//  调用代码The semi-unique identifier for this instance. This is 0 if the id has not yet been created.
// private int _id;
// public int Id
// {
//     get { return IdManager<AsyncConditionVariable>.GetId(ref _id); }
// }

namespace Foundatio.AsyncEx
{
    /// <summary>
    /// Allocates Ids for instances on demand. 0 is an invalid/unassigned Id. Ids may be non-unique in very long-running systems. This is similar to the Id system used by <see cref="System.Threading.Tasks.Task"/> and <see cref="System.Threading.Tasks.TaskScheduler"/>.
    /// </summary>
    /// <typeparam name="TTag">The type for which ids are generated.</typeparam>
// ReSharper disable UnusedTypeParameter
    internal static class IdManager<TTag>
    // ReSharper restore UnusedTypeParameter
    {
        /// <summary>
        /// The last id generated for this type. This is 0 if no ids have been generated.
        /// </summary>
// ReSharper disable StaticFieldInGenericType
        private static int _lastId;
        // ReSharper restore StaticFieldInGenericType

        /// <summary>
        /// Returns the id, allocating it if necessary.
        /// </summary>
        /// <param name="id">A reference to the field containing the id.</param>
        public static int GetId(ref int id)
        {
            // If the Id has already been assigned, just use it.
            if (id != 0)
                return id;

            // Determine the new Id without modifying "id", since other threads may also be determining the new Id at the same time.
            int newId;

            // The Increment is in a while loop to ensure we get a non-zero Id:
            //  If we are incrementing -1, then we want to skip over 0.
            //  If there are tons of Id allocations going on, we want to skip over 0 no matter how many times we get it.
            do
            {
                newId = Interlocked.Increment(ref _lastId);
            } while (newId == 0);

            // Update the Id unless another thread already updated it.
            Interlocked.CompareExchange(ref id, newId, 0);

            // Return the current Id, regardless of whether it's our new Id or a new Id from another thread.
            return id;
        }
    }
}



## Novell.Directory.Ldap

    public struct DebugId
    {
        private static int _id;
        private static int GetNextId()
        {
            // Rollover is OK in case we somehow end up with more than 2147483647 calls to this...
            unchecked
            {
                return Interlocked.Increment(ref _id);
            }
        }

        /// <summary>
        /// A name that can identify an object instance.
        /// </summary>
        string Name { get; }

        /// <summary>
        /// An incrementing Id for every new object.
        /// Note: This Id increments for every newly generated DebugId,
        /// regardless of the Name.
        /// </summary>
        int Id { get; }

        public override string ToString()
             => "[#" + Id + "] " + Name;

        public DebugId(string name)
        {
            Name = name;
            Id = GetNextId();
        }

        public static DebugId ForType<T>()
            => new DebugId(typeof(T).FullName);
    }