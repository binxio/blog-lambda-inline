exports.handler = function(event, context, callback) {
console.log(event);
    const response = {
        statusCode: 200,
        body: JSON.stringify('Hello Node')
    };
    callback(null, response);
};
