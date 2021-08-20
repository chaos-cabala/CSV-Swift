# CSV-Swift
只有核心解析算法,外围功能未添加
用不同的文件测试,大概比SwiftCSV快6到10倍
SwiftCSV的init过程会解析一次,后面获取内容的时候会再重复解析一次,应该算个BUG,把这个解决掉的话,SwiftCSV的速度能提升1倍,然后把SwiftCSV解析器改成先转换为Data,然后遍历data判断的话,速度还能再提升2倍,但即使如此,还是比不上本方案的速度
本方案速度快的核心是先用.components(separatedBy: CharacterSet)快速拆分,然后再判断合并,不用逐字符遍历了.
