import Foundation

nonisolated enum RestaurantSort: CaseIterable, Sendable {
    case standard
    case rating
    case deliveryTime

    var title: String {
        switch self {
        case .standard: "Default"
        case .rating: "Rating (high to low)"
        case .deliveryTime: "Delivery time (fastest)"
        }
    }
}

/// Pure search, filter and sort logic for the restaurant list.
nonisolated enum RestaurantFilter {

    static func apply(to restaurants: [Restaurant],
                      query: String,
                      openOnly: Bool,
                      sort: RestaurantSort) -> [Restaurant] {
        let query = query.trimmingCharacters(in: .whitespacesAndNewlines)
        var result = restaurants.filter { restaurant in
            let matchesQuery = query.isEmpty
                || restaurant.name.localizedCaseInsensitiveContains(query)
                || restaurant.cuisine.localizedCaseInsensitiveContains(query)
            return matchesQuery && (!openOnly || restaurant.isOpen)
        }

        switch sort {
        case .standard:
            break
        case .rating:
            result.sort { ($0.rating, $1.name) > ($1.rating, $0.name) }
        case .deliveryTime:
            result.sort { ($0.deliveryMinutes, $0.name) < ($1.deliveryMinutes, $1.name) }
        }
        return result
    }
}
