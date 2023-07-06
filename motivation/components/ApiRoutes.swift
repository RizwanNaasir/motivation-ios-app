//
// Created by InterLink on 7/3/23.
//

import Foundation

let API_BASE_URL = "https://motivation-api.fly.dev/api/"

let LOGIN_ROUTE = `API_BASE_URL` + "auth/login"
let REGISTER_ROUTE = `API_BASE_URL` + "auth/register"

let QUOTES_LIST_ROUTE = `API_BASE_URL` + "quote/list"
let REFRESH_QUOTES_ROUTE = `API_BASE_URL` + "quote/refresh"
let ADD_TO_FAVORITES_ROUTE = `API_BASE_URL` + "quote/like/"