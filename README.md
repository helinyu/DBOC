# DBOC

[![CI Status](https://img.shields.io/travis/helinyu/DBOC.svg?style=flat)](https://travis-ci.org/helinyu/DBOC)
[![Version](https://img.shields.io/cocoapods/v/DBOC.svg?style=flat)](https://cocoapods.org/pods/DBOC)
[![License](https://img.shields.io/cocoapods/l/DBOC.svg?style=flat)](https://cocoapods.org/pods/DBOC)
[![Platform](https://img.shields.io/cocoapods/p/DBOC.svg?style=flat)](https://cocoapods.org/pods/DBOC)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

DBOC is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'DBOC'
```

# 0x 01
> 同步获取的方式，暂时先不支持，同事也不推荐使用

## Author

helinyu, 2319979647@qq.com

## License

DBOC is available under the MIT license. See the LICENSE file for more info.


遗留问题：

0）有关的数据的处理内容， 看看
1)order by 后面可以接入多个值
2) 有就更新， 没有就插入，有没有这样的需求？
3) //        NSString *sql = [NSString stringWithFormat:@"select comic_name as comicName,chapter_name as chapterName,urls from ComicChapter where length(urls) > 0 and comic_id = '%@';",model.comic_id];
 这个length的函数的写法， 看看这个要怎么写
 
 4） 获取对应的有关方法，如果当前类没有，直接用这个item的class来进行判断
 > 1: tablename > 2:tableMapClass > 3:tableObjClass > item.class 【获取的优先权】
5 ） 更新要处理好， 没有数据就插入，有数据就更新的逻辑
6） 更新、删除等，都是有单个、或者集合的 ， 所以都有item， 以及list内容
7） 创建表的时候， 是否创建成功了， 如果是新创建的， 只是在原来的基础上修改， 还有就没有操作的
8） NSString *sql = @"insert into ComicChapterReadHistory (comicid,chapterid,pagenumber,readtime,totalcount)select comic_id,chapter_id,case when a.pagenumber = -1 then 0 else a.pagenumber end,read_time,0 from readbtnmodel a left join ComicChapterReadHistory b on a.comic_id = b.comicid and a.chapter_id = b.chapterid  where  b.comicid is null;";
[[DataBaseManager sharedManager]executeUpdateSql:sql]; 这条语句以后更新 case 这条语句里面的判断，看看里面是可以怎么精心判断的
9）怎么样去闺蜜写法上面的错误
