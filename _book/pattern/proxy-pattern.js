let obj = {
    a: 1,
    b: 2,
  }
  
  const p = new Proxy(obj, {
    get(target, key) {
      if (key === 'c') {
        return '我是自定义的一个结果';
      } else {
        return target[key];
      }
    },
  
    set(target, key, value) {
      if (value === 4) {
        target[key] = '我是自定义的一个结果';
      } else {
        target[key] = value;
      }
    }
  })
  
  console.log(obj.a) 
  // 1 
  console.log(obj.c) // undefined 
  console.log(p.a) // 1 
  console.log(p.c) // 我是自定义的一个结果
  
  obj.name = '李白';
  console.log(obj.name); // 李白
  obj.age = 4;
  console.log(obj.age); // 4
  
  p.name = '李白';
  console.log(p.name); // 李白
  p.age = 4;
  console.log(p.age); // 我是自定义的一个结果 