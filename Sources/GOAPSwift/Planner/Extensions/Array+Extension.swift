import Foundation

extension Array {

    public func insertionIndex(of item: Element, _ isOrderedBefore: (Element, Element) -> Bool) -> Int {
        var left = 0
        var right = self.count - 1
        while left <= right {
            let mid = (left + right) / 2
            if isOrderedBefore(self[mid], item) {
                left = mid + 1
            } else if isOrderedBefore(item, self[mid]) {
                right = mid - 1
            } else {
                return mid
            }
        }

        return left
    }

    public mutating func insertInOrder(of item: Element, _ isOrderedBefore: (Element, Element) -> Bool){
        let index = self.insertionIndex(of: item, isOrderedBefore)
        self.insert(item, at: index)
    }

}