//父类
class BaseBuilder {
  init() {
    Object.keys(this).forEach(key => {
      const withName = `with${key.substring(0, 1).toUpperCase()}${key.substring(1)}`;
      this[withName] = value => {
        this[key] = value;
        return this;
      }
    })
  }

  build() {
    const keysNoWithers = Object.keys(this).filter(key => typeof this[key] !== 'function');

    return keysNoWithers.reduce((returnValue, key) => {
      return {
        ...returnValue,
        [key]: this[key]
      }
    }, {})
  }
}

//子类1: 书籍建造者类
class BookBuilder extends BaseBuilder {
  constructor() {
    super();

    this.name = '';
    this.author = '';
    this.price = 0;
    this.category = '';
    
    super.init();
  }
}

//子类2: 印刷厂建造者类
class printHouseBuilder extends BaseBuilder {
  constructor() {
    super();

    this.name = '';
    this.location = '';
    this.quality = '';

    super.init();
  }
}

//调用书籍建造者类
const book = new BookBuilder()
  .withName("高效能人士的七个习惯")
  .withAuthor('史蒂芬·柯维')
  .withPrice(51)
  .withCategory('励志')
  .build();


//调用印刷厂建造类
const printHouse = new printHouseBuilder()
  .withName('新华印刷厂')
  .withLocation('北京海淀区')
  .withQuality('A')
  .build();