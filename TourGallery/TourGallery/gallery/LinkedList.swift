//
//  LinkedList.swift
//  TourGallery
//
//  Created by 김동준 on 2022/07/07.
//

import Foundation

class Node<T> {
    var nextNode: Node?
    var val: T? = nil
}

class LinkedList<T>: IteratorProtocol, Sequence {
    lazy var currentNode: Node? = head
    
    func next() -> T? {
        let val = currentNode?.val
        currentNode = currentNode?.nextNode
        return val
    }
    
    typealias Element = T
    
    var head: Node<T>?
    var tail: Node<T>?
    var count: Int = 0 {
        didSet{
            if count == 0{
                head = nil
                tail = nil
            }
        }
    }
    
    func add(node: Node<T>) {
        guard var currentNode = self.head else {
            head = node
            tail = node
            count += 1
            return
        }
        tail?.nextNode = node
        tail = tail?.nextNode
        count += 1
    }
    
    func delete() -> T? {
        if count > 0{
            let val = head?.val
            head = head?.nextNode
            count -= 1
            
            return val
        }
        
        return nil
    }
    
    func size() -> Int {
        return self.count
    }
    
    func isEmpty() -> Bool {
        return count == 0 ? true : false
    }
    
    func front() -> T? {
        return head?.val
    }
    
    func back() -> T?{
        return tail?.val
    }
}
