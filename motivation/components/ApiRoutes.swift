//
// Created by InterLink on 7/3/23.
//

import Foundation

let API_BASE_URL = "https://motivation-api.fly.dev/api/"

let LOGIN_ROUTE = `API_BASE_URL` + "auth/login"
let REGISTER_ROUTE = `API_BASE_URL` + "auth/register"

let USER_PROFILE = `API_BASE_URL` + "user/profile"

let QUOTES_LIST_ROUTE = `API_BASE_URL` + "quote/list"
let REFRESH_QUOTES_ROUTE = `API_BASE_URL` + "quote/refresh"
let ADD_TO_FAVORITES_ROUTE = `API_BASE_URL` + "quote/like/"

let STORIES_LIST_ROUTE = `API_BASE_URL` + "story/list"
let REFRESH_STORIES_ROUTE = `API_BASE_URL` + "story/refresh"
let ADD_TO_FAVORITES_STORIES_ROUTE = `API_BASE_URL` + "story/like/"

let FAVORITE_QUOTES_LIST_ROUTE = `API_BASE_URL` + "favourite/list-quotes"
let FAVORITE_STORIES_LIST_ROUTE = `API_BASE_URL` + "favourite/list-stories"

let GOAL = `API_BASE_URL` + "goal"