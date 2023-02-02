"use strict";

function handler(event) {
    var response = event.response
    var headers = response.headers

    var second = 60 * 60 * 24 * 365

    headers['cache-control'] = {value: 'public, max-age=' + second.toString()}

    return response
}