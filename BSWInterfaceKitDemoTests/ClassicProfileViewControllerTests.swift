//
//  Created by Pierluigi Cifani on 12/02/2017.
//

import XCTest
import FBSnapshotTestCase
import Deferred
@testable import BSWInterfaceKit

class ClassicProfileViewControllerTests: BSWSnapshotTest {

    func testSampleLayout() {

        let viewModel = ClassicProfileViewModel.buffon()
        let detailVC = ClassicProfileViewController(viewModel: viewModel)
        let navController = UINavigationController(rootViewController: detailVC)

        waitABitAndVerify(viewController: navController)
    }
    
}
