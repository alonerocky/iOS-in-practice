//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

class TimesTable {
    
    let multiplier: Int
    init(multiplier: Int) {
        self.multiplier = multiplier
    }
    
    func get(num: Int) -> Int {
        return self.multiplier *  num
    }
    
    subscript(num: Int) -> Int {
        return num * self.multiplier
        
    }
}

var table1: TimesTable = TimesTable(multiplier: 3)

print(table1.get(5))

print(table1[6])

class LRUCache<K: Hashable, V> {
    var capacity: Int
    //header next point to the eldest
    //header prev point to the newest
    //it is a circle
    var header: DoubleLinkedListEntry<K, V>
    var dictionary: Dictionary<K, DoubleLinkedListEntry<K, V>>
    
    init(capacity: Int) {
        self.capacity = capacity
        dictionary = Dictionary<K, DoubleLinkedListEntry<K, V>>(minimumCapacity: capacity)
        header = DoubleLinkedListEntry<K, V>()
        header.prev = header
        header.next = header
    }
    
    func count() -> Int {
        return dictionary.count
    }
    
    func get(key: K) -> V? {
        if let entry = dictionary[key] {
            entry.remove()
            entry.addBefore(header)
            return entry.value
        } else {
            return nil
        }
    }
    
    func set(key: K, value: V?) {
        if value == nil {
            //remove the entry if exist
            if let entry = dictionary[key] {
                entry.remove()
                dictionary.removeValueForKey(entry.key!)
            }
        } else {
            //replace 
            if let entry = dictionary[key] {
                entry.remove()
                dictionary.removeValueForKey(entry.key!)
            }
            let newEntry = DoubleLinkedListEntry(key: key, value: value)
            dictionary[key] = newEntry
            newEntry.addBefore(header)
            if dictionary.count > self.capacity {
                removeEldestEntry()
            }
        }
    }
    
    subscript(key: K) -> V? {
        get {
            if let entry = dictionary[key] {
                entry.remove()
                entry.addBefore(header)
                return entry.value
            } else {
                return nil
            }
        }
        set(value) {
            if value == nil {
                //remove the entry if exist
                if let entry = dictionary[key] {
                    entry.remove()
                    dictionary.removeValueForKey(entry.key!)
                }
            } else {
                //replace
                if let entry = dictionary[key] {
                    entry.remove()
                    dictionary.removeValueForKey(entry.key!)
                }
                let newEntry = DoubleLinkedListEntry(key: key, value: value)
                dictionary[key] = newEntry
                newEntry.addBefore(header)
                if dictionary.count > self.capacity {
                    removeEldestEntry()
                }
            }

        }
    }

    
    func removeEldestEntry() {
        if header.next === header {
            //empty
        } else {
            dictionary.removeValueForKey(header.next!.key!)
            header.next?.remove()
        }
        
    }
}

class DoubleLinkedListEntry<K: Hashable, V> {
    var key: K? = nil
    var value: V? = nil
    var prev: DoubleLinkedListEntry<K, V>? = nil
    var next: DoubleLinkedListEntry<K, V>? = nil
    
    init() {
        
    }
    
    init(key: K, value: V?) {
        self.key = key
        self.value = value
    }
    
    //add self before the entry
    func addBefore(entry: DoubleLinkedListEntry) {
        prev = entry.prev
        next = entry
        prev?.next = self
        next?.prev = self
    }
    
    func addAfter(entry: DoubleLinkedListEntry) {
        prev = entry
        next = entry.next
        prev?.next = self
        next?.prev = self
    }
    
    func remove() {
        prev?.next = next
        next?.prev = prev
        prev = nil
        next = nil
    }
}

var lruCache = LRUCache<Int, Int>(capacity: 1)
lruCache[2] = 1
print(lruCache[2])
lruCache[2] = 2
print(lruCache[2])

lruCache[1] = 1
lruCache[4] = 2
print(lruCache[2])

let cache = LRUCache<String, Float>(capacity: 7)

//Add Key, Value pairs
cache["AAPL"] = 114.63
cache["GOOG"] = 533.75
cache["YHOO"] = 50.67
cache["TWTR"] = 38.91
cache["BABA"] = 109.89
cache["YELP"] = 55.17
cache["BABA"] = 109.80
print(cache.count())
print(cache["BABA"])

cache["TSLA"] = 231.43

print(cache.count())
print(cache["TSLA"])
cache["AAPL"] = 113.41
print(cache.count())
print(cache["AAPL"])
cache["GOOG"] = 533.60
cache["AAPL"] = 113.01

cache["AAPL"] = nil
cache["ARMH"] = 49.0
print(cache.count())
print(cache["ARMH"])

print(cache["YHOO"])
print(cache["AAPL"])

