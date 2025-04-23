module.exports = {
  startTimer,
  stopTimer,
}

function startTimer(context, events, done) {
  context.vars.startTime = Date.now();
  console.log("File", context.vars.$loopCount, "(", context.vars.$loopElement.existing, "). Download started (", context.vars.startTime, ")");
  events.emit('rate','download_started');
  
  return done();
}

function stopTimer(context, events, done) {
  const endTime = Date.now();
  const downloadTime = endTime - context.vars.startTime;

  console.log("File", context.vars.$loopCount, "(", context.vars.$loopElement.existing, "). Download finished (", endTime, "). Download time: ", downloadTime);
  events.emit('histogram', 'download_time', downloadTime);
  events.emit('rate', 'download_finished');

  return done();
}
