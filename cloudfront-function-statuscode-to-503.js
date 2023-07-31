function handler(event) {
    if (event.response.statusCode == 200) {
        event.response.statusCode = 503;
        event.response.statusDescription = 'Service Temporarily Unavailable';
    }
    return event.response;
}
