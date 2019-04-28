/*
 * @Author: zx 
 * @Date: 2019-04-27 10:04:16 
 * @Last Modified by: zx
 * @Last Modified time: 2019-04-27 10:08:16
 */

class PubSub {
    constructor() {
        // 事件处理函数集合
        this.handles = {};
    }
    
    // 订阅模式
    on(eventType, handle) {
        if (!this.handles.hasOwnProperty(eventType)) {
            this.handles[eventType] = [];
        }
        if (typeof handle === 'function') {
            this.handles[eventType].push(handle);
        } else {
            throw new Error('缺少回调函数');
        }
        return this; // 实现链式操作
    }

    // 发布事件
    emit(eventType, ...args){
        if (this.handles.hasOwnProperty(eventType)) {
            this.handles[eventType].forEach((item, index, arr) => {
                item.apply(null, args);
            });
        } else {
            throw new Error('"${eventType}"事件未注册');
        }
        return this; // 实现链式操作
    }

    // 删除事件
    off(eventType, handle){
        console.log()
        if (!this.handles.hasOwnProperty(eventType)){
            throw new Error('"${eventType}"事件未注册');
        } else if (typeof handle !== 'function'){
            throw new Error('缺少回调函数');
        } else {
            this.handles[eventType].forEach((item, index, arr) => {
                if (item === handle) arr.splice(index, 1);
            });
        }
        return this; // 实现链式操作
    }
}

let callback = function(){
    console.log('you are so nice');
};
let pubSub = new PubSub();
pubSub.on('completed', (...args)=>{
    console.log(args.join(' '));
}).on('completed', callback);

pubSub.emit('completed', 'Are', 'you', 'ok!');
pubSub.off('completed', callback);
pubSub.emit('completed', 'Hello,', 'Mi', 'fans');