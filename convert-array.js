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


/**
 * refiguring out interpolation
 */

const size = 9;
const allPointsValues = [[[-6.5, -6.5, -6.5], [-6.5, -6.5, -6.5], [-6.5, -6.5, -6.5]], [[2.5, 2.5, 2.5], [2.5, 2.5, 2.5], [2.5, 2.5, 2.5]], [[11.5, 11.5, 11.5], [11.5, 11.5, 11.5], [11.5, 11.5, 11.5]]];
const i = 0;
const j = 0;
const k = 0

console.log((() => {
  let output = [];

  for (var l = 0; l <= 2; l++) {
    // alternate m so that we get all four sides
    for(var m = 0; m <= 3; m++) {
      var positionOne = [(l == 0) ? i : ((l == 1) ? i + m % 2 : i + (m >= 2 ? 1 : 0)), (l == 1) ? j : ((l == 0) ? j + ((m >= 2) ? 1 : 0) : j + m % 2), (l == 2) ? k : ((l == 0) ? k + m % 2 : k + (m >= 2 ? 1 : 0))]
      var positionTwo = [positionOne[0] + ((l == 0) ? 1 : 0), positionOne[1] + ((l == 1) ? 1 : 0), positionOne[2] + ((l != 2) ? 1 : 0)]
      var valueOne = allPointsValues[positionOne[0]][positionOne[1]][positionOne[2]]
      let valueTwo = allPointsValues[positionTwo[0]][positionTwo[1]][positionTwo[2]]
      // check if two points have opposite signs because that is when there is a point on the edge
      if ((valueOne < 0) ? (valueTwo > 0) : (valueTwo < 0)) {
        // this if might never be called
        if (valueOne == valueTwo) {
          edgePoints[(l * 4 + m)]
        } else {
          let temp = [];
          for(var n = 0; n <= 2; n++) {
            // i derived this equation using point slope form
            temp.push(valueOne * size / (valueOne - valueTwo))
          }
          output.push(temp);
        }
      } else {
        // this needs parens, idk why
        // edgePoints[(l * 4 + m)]  
        output.push(0)  
      }             
    }
  }
  return(output);
})());

/**
 * more testing with newest stuff to figure out why when one of the points is zero, the algorithm picks the
 * the opposite side than it should to put the point
 */

const size = 10;
const allPointsValues = [[[-20, -20, -20], [-10, -10, -10], [0, 0, 0]], [[-10, -10, -10], [0, 0, 0], [10, 10, 10]], [[0, 0, 0], [10, 10, 10], [20, 20, 20]]]
const i = 1;
const j = 0;
const k = 0;

console.log((() => {
  let output = [];
  for (var l = 0; l <= 2; l++) {
    // alternate m so that we get all four sides
    for(var m = 0; m <= 3; m++) {
      var positionOne = [(l == 0) ? i : ((l == 1) ? i + m % 2 : i + (m >= 2 ? 1 : 0)), (l == 1) ? j : ((l == 0) ? j + ((m >= 2) ? 1 : 0) : j + m % 2), (l == 2) ? k : ((l == 0) ? k + m % 2 : k + (m >= 2 ? 1 : 0))]
      var positionTwo = [positionOne[0] + ((l == 0) ? 1 : 0), positionOne[1] + ((l == 1) ? 1 : 0), positionOne[2] + ((l == 2) ? 1 : 0)]
      var valueOne = allPointsValues[positionOne[0]][positionOne[1]][positionOne[2]]
      let valueTwo = allPointsValues[positionTwo[0]][positionTwo[1]][positionTwo[2]]
      console.log(positionOne);
      console.log(positionTwo);
      // check if two points have opposite signs because that is when there is a point on the edge
      if ( valueOne == 0 || valueTwo == 0 || (valueOne < 0) ? (valueTwo > 0) : (valueTwo < 0)) {
        // this if might never be called
        if (valueOne == valueTwo) {
          0
        } else {
          let temp = [];
          for(var n = 0; n <= 2; n++) {
            // i derived this equation using point slope form
            if (positionTwo[n] - positionOne[n] === 1){
              temp.push(valueOne * size / (valueOne - valueTwo))
            } else if (positionOne[n] === 1) {
              temp.push(size);
            } else {
              temp.push(0);
            }
          }
          output.push(temp);
        }
      } else {
        // this needs parens, idk why
        // edgePoints[(l * 4 + m)]  
        output.push(0)  
      }             
    }
  }
  return(output);
})());

/**
 * try two of up top stuff
 */
const size = 10;
const allPointsValues = [[[-20, -20, -20], [-10, -10, -10], [0, 0, 0]], [[-10, -10, -10], [0, 0, 0], [10, 10, 10]], [[0, 0, 0], [10, 10, 10], [20, 20, 20]]]
const i = 1;
const j = 0;
const k = 0;

console.log((() => {
  let output = [];
  for (var l = 0; l <= 2; l++) {
    // alternate m so that we get all four sides
    for(var m = 0; m <= 3; m++) {
       var positionOne = [(l == 0) ? i : ((l == 1) ? i + m % 2 : i + (m >= 2 ? 1 : 0)), (l == 1) ? j : ((l == 0) ? j + ((m >= 2) ? 1 : 0) : j + m % 2), (l == 2) ? k : ((l == 0) ? k + m % 2 : k + (m >= 2 ? 1 : 0))]
      var positionTwo = [positionOne[0] + ((l == 0) ? 1 : 0), positionOne[1] + ((l == 1) ? 1 : 0), positionOne[2] + ((l == 2) ? 1 : 0)]
      var valueOne = allPointsValues[positionOne[0]][positionOne[1]][positionOne[2]]
      let valueTwo = allPointsValues[positionTwo[0]][positionTwo[1]][positionTwo[2]]
      console.log("positionone")
      console.log("  ", positionOne);
      console.log("position two")
      console.log("  ", positionTwo);
      // check if two points have opposite signs because that is when there is a point on the edge
      if ( valueOne == 0 || valueTwo == 0 || (valueOne < 0) ? (valueTwo > 0) : (valueTwo < 0)) {
        // this if might never be called
        if (valueOne == valueTwo) {
          0
        } else {
          let temp = [];
          for(var n = 0; n <= 2; n++) {
            // i derived this equation using point slope form
            if (positionTwo[n] - positionOne[n] === 1) {
              temp.push(valueOne * size / (valueOne - valueTwo))
            } else if (positionOne[n] === 1) {
              temp.push(size);
            } else {
              temp.push(0);
            }
          }
          output.push(temp);
        }
      } else {
        // this needs parens, idk why
        // edgePoints[(l * 4 + m)]  
        output.push(0)  
      }
  console.log("output");
  // console.log(output)
  console.log("  ", output[m + 4 * l])
    }
  }
  return(output);
})());