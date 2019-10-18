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

/**
 * code to figure out which points are which for the interpolation
 * and converting my weird points to a normal array
 */
var i = 0, j = 0, k = 0

for (l = 0; l <= 2; l++) {
  // alternate m so that we get all four sides
  for(m = 0; m <= 3; m++) {
    var positionOne = [(l == 0) ? i : ((l == 1) ? i + m % 2 : i + (m >= 2 ? 1 : 0)), (l == 1) ? j : ((l == 0) ? j + ((m >= 2) ? 1 : 0) : j + m % 2), (l == 2) ? k : ((l == 0) ? k + m % 2 : k + (m >= 2 ? 1 : 0))];
    var positionTwo = [positionOne[0] + ((l == 0) ? 1 : 0), positionOne[1] + ((l == 1) ? 1 : 0), positionOne[2] + ((l == 2) ? 1 : 0)];

    console.log("start");
    console.log("   m", m);
    console.log("   l", l);
    console.log("   array value", m + l * 4)
    console.log("   position one: ", positionOne);
    console.log("   position two: ", positionTwo);
  }
}