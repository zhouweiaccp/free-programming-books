     随着dva框架和pro框架的使用，Redux在React项目开发过程中，变得越来越重要了，也由于各大脚手架的集成，使用redux正变得越来越简单，此文主要是总结了在pro框架下，Redux的使用方法。

1、关于models文件的一点说明
     pro脚手架的目录结构，十分清晰，其中models文件夹下的文件一般而言主要是调用services层，并对数据进行数据，现对其内容构成做如下说明：，
         ①namespace：命名空间，必有属性，唯一标识一个model；

         ②state：命名空间下对应的全部值，建议属性（如果不使用redux来维护数据，一般不会有state，如果使用redux来维护数据，则一般维护的是state中的值）；

         ③effects：主要用于异步请求（调用service）、触发action（调用）、从state里获取数据；

              effets中的函数形如下：

 *fucntionName({ payload,callback}, { call,put,select }) {
     //payload:调用接口时需要的入参；
     //callback:回调函数
    //call用于调用异步逻辑(调用service层) ；
    //put 用于触发action，在代码中表现为调用reducers中的方法
    //select 用于过滤model中state的值，即取值 
 
    },
 

       ④reducers:主要用来改变state中的值，即接受 state 和 action，返回老的或新的 state ：(state, action) => state

 functionName: (state, action) => {
     return {
        ...state,
        ...action.payload
      }
 }
2、关于models中state和payload值获取的总结
    models文件中，对state和payload的操作很多，可以说model中的操作大都是围绕着state和payload展开的，下面关于在models文件内部如何获取这两个的值做如下总结

2.1如何获取state的值
 在effects中： 通过select过滤

       const stateTemp = yield select(state => state.avtivitydev)

 在reducers中：

       reducers中函数接受 state 和 action，返回老的或新的 state即reducers所有方法的第一个参数即为state

 

2.2如何获取payload的值
     在effects中： effects中方法的第一个参数的第一个值即为payload，

        *fucntionName({ payload,callback}, { call,put,select }) {
      },

     在reducers中：通过action.payload

       functionName: (state, action) => {
             let {payload}=action.payload;
        }

3Redux存取数据
          models层主要是对数据的操作，数据的操作一般而言增删改查，简言之，存取操作

3.1存入数据
         在effects中调用reducers中的方法，对state进行操作，分两步：

      step1：在effects中调用reducers中的方法

           yield put({ type: "save", payload: data });

*fetch({ payload }, { select, call, put }) {
 const { data } = yield getData();
 yield put({ type: "save", payload: data });
},
      step2：在reducers中对state进行操作（注意：不能直接修改state）

save(state, action) {
  return {
    ...state,
    data: action.payload,
    loading: false
  };
},
 

3.2取出数据
    在页面(pages层下的)通过“this.props.命名空间”来获取对应命名空间中的state

    const {   命名空间: { stateData1, stateData2}} =this.props;

const {
  user: { base, family},
} = this.props;
 

 

 

4、题外小结——基于action的跳转总结
import { routerRedux } from 'dva/router';

①在effects内部如何跳转？

yield put(routerRedux.push('/logout'));

②在effects之外，一般是页面中如何跳转？

dispatch(routerRedux.push('/logout'));

③携带参数如何跳转？

routerRedux.push({

  pathname: '/logout',

  query: {

    page: 2,

  },

});

5、结语
     直接使用pro脚手架进行开发，目录结构很清晰，但是关于models的一些东西，个人觉得如何单纯的照猫画虎还行，但要理解真挺难的，各种看博客，这篇文章算是对自己学习摸索的一个总结吧，感觉没啥逻辑，基本是自己学习过程中疑惑的解决历程。前端技术更新换代太快了，学得快也忘记得快，看来以后条件允许要多些博客了，这样，即使全忘记了，还有博客上的一点记录。

 https://blog.csdn.net/wuChiSha/article/details/90273390