import XCTest
@testable import Dabao

final class RestaurantFilterTests: XCTestCase {

    private func make(_ name: String, cuisine: String = "Hawker", rating: Double = 4.0,
                      minutes: Int = 20, isOpen: Bool = true) -> Restaurant {
        Restaurant(id: name, name: name, cuisine: cuisine, rating: rating,
                   deliveryMinutes: minutes, deliveryFee: 1, isOpen: isOpen,
                   imageName: "", menu: [])
    }

    private lazy var sample = [
        make("Alpha", cuisine: "Hawker", rating: 4.2, minutes: 30, isOpen: true),
        make("Bravo", cuisine: "Sichuan", rating: 4.8, minutes: 40, isOpen: false),
        make("Charlie", cuisine: "Coffee shop", rating: 4.5, minutes: 10, isOpen: true)
    ]

    private func names(_ query: String = "", openOnly: Bool = false,
                       sort: RestaurantSort = .standard) -> [String] {
        RestaurantFilter.apply(to: sample, query: query, openOnly: openOnly, sort: sort).map(\.name)
    }

    func test_defaultKeepsOrder() {
        XCTAssertEqual(names(), ["Alpha", "Bravo", "Charlie"])
    }

    func test_searchMatchesNameOrCuisineIgnoringCase() {
        XCTAssertEqual(names("alp"), ["Alpha"])
        XCTAssertEqual(names("SICHUAN"), ["Bravo"])
        XCTAssertEqual(names("  "), ["Alpha", "Bravo", "Charlie"])
    }

    func test_openOnlyHidesClosed() {
        XCTAssertEqual(names(openOnly: true), ["Alpha", "Charlie"])
    }

    func test_sortByRatingDescending() {
        XCTAssertEqual(names(sort: .rating), ["Bravo", "Charlie", "Alpha"])
    }

    func test_sortByDeliveryTimeAscending() {
        XCTAssertEqual(names(sort: .deliveryTime), ["Charlie", "Alpha", "Bravo"])
    }

    func test_combinedSearchOpenAndSort() {
        XCTAssertEqual(names("a", openOnly: true, sort: .rating), ["Charlie", "Alpha"])
    }
}
