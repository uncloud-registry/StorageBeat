let userNum = 0;

module.exports = {
    startDownload,
    finishDownload,
    userLimitReached,
}

function startDownload(requestParams, context, ee, next) {
    userNum++;
    next();
}

function finishDownload(context, ee, next) {
    userNum--;
    next();
}

function userLimitReached(context, next) {
    const continueWaiting = userNum >= 5;
    next(continueWaiting);
}