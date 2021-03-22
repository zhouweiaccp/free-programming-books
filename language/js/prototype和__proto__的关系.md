



## prototype和__proto__的关系
1. https://www.cnblogs.com/Narcotic/p/6899088.html
我们创建的每个函数都有一个prototype（原型）属性，这个属性是一个对象，它的用途是包含可以由特定类型的所有实例共享的属性和方法。（这个对象下面有个属性，这个属性是另外一个对象的应用 ，这个属性就是一个对象。）
function是对象，function的原型prototype也是对象，它们都会具有对象共有的特点。即：对象具有属性__proto__，每个对象都会在其内部初始化一个属性，就是__proto__，当我们访问一个对象的属性 时，如果这个对象内部不存在这个属性，那么他就会去__proto__里找这个属性，这个__proto__又会有自己的__proto__，于是就这样 一直找下去，也就是我们平时所说的原型链的概念。__proto__可称为隐式原型，一个对象的隐式原型指向构造该对象的构造函数的原型，这也保证了实例能够访问在构造函数原型中定义的属性和方法。

funcition这个特殊的对象，除了和其他对象一样有上述_proto_属性之外，还有自己特有的属性——原型属性（prototype），这个属性是一个指针，指向一个对象，这个对象的用途就是包含所有实例共享的属性和方法（我们把这个对象叫做原型对象）。prototype是通过调用构造函数而创建的那个对象实例的原型对象。使用原型对象的好处是可以让所有对象实例共享它所包含的属性和方法，不必在构造函数中定义对象实例的信息，而是可以将这些信息直接添加到原型对象中。原型对象也有一个属性，叫做constructor，这个属性包含了一个指针，指回原构造函数。

//a作为构造函数时的prototype属性与a作为普通函数时的__proto__属性并不相等
console.log(a.prototype == a.__proto__);//false

console.log(a.__proto__);         //function (){}
console.log(a.__proto__ == Function.prototype);//true

//a作为一个普通函数调用时，它的构造函数是内置对象Function，所以它指向的原型对象，就是Function.prototype.
//其实这个和console.log(b.__proto__ == a.prototype)是一样的道理

//a作为构造函数时，它的原型，和它的原型的原型
console.log(a.prototype);                   //a{}
console.log(a.prototype.__proto__);  //Object{}

//a作为普通函数时，它原型的原型
console.log(a.__proto__.__proto__); //Object{}

console.log(a.__proto__.__proto__ == a.prototype.__proto__); //true

 



 ```js
 //https://gitlab.com/meno/dropzone/blob/42855f99f3d2ac0740b717419118ce6973945d8f/website/js/dropzone.js#L31-40
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) {
       for (var key in parent) {
        if (__hasProp.call(parent, key)) child[key] = parent[key];
      }
      function ctor() { this.constructor = child; }
      ctor.prototype = parent.prototype;//父级方法给 类
      child.prototype = new ctor();//子级 方法= 新类的实例
      child.__super__ = parent.prototype; 
      return child;
       };
 ```


 ![](.\js_原型_proto_constructor_prototype)