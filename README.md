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
1)order by 后面可以接入多个值
2) 有就更新， 没有就插入，有没有这样的需求？
3) //        NSString *sql = [NSString stringWithFormat:@"select comic_name as comicName,chapter_name as chapterName,urls from ComicChapter where length(urls) > 0 and comic_id = '%@';",model.comic_id];
 这个length的函数的写法， 看看这个要怎么写
