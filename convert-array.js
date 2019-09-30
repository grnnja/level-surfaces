/**
 * code to convert array of points with extra -1s to array of array of array of
 * 3 point groups so that openscad can actually use our data
 */

var newPoints = points.map(x => {
  return x.filter(y => {
    if (y !== -1) {
      return true
    }
    return false
  })
})

var newestPoints = newPoints.map(x => {
  var arrayOfArrays = [];
  var i;

  for(i = 0; i < x.length/3; i++) {
    arrayOfArrays.push(x.slice(3 * i, 3 * i + 3))
  }

  return arrayOfArrays
})

console.log(newestPoints);