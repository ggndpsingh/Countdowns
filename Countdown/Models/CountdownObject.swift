//  Created by Gagandeep Singh on 20/9/20.

import CoreData

extension CountdownObject {
    class func createFetchRequest() -> NSFetchRequest<CountdownObject> {
        return NSFetchRequest<CountdownObject>(entityName: "CountdownObject")
    }
}
