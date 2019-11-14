/**
* premise is that we iterate over each location then evaluate if the points should exist on corners of
* cube at the location then use drawMarchingCube to render each cube
*/

include <./point-list.scad>

// TODO: add support for multiple functions, lines, and points

bounds = 5;

resolution = 0.5;

interpolation = true;

// the following are functions set to work with a bounds of 5 and a resolution of 0.5

// cylinder
// function f(x, y, z) = pow(x, 2) + pow(y, 2) - 25;

// sphere
// function f(x, y, z) = pow(x, 2) + pow(y, 2) + pow(z, 2) - 25;

// hyperbolic paraboloid
// function f(x, y, z) = pow(x, 2) - pow(y, 2) - z;

// plane
// function f(x, y, z) = x + y + z + 0;

// paraboloid
// function f(x, y, z) = pow(x, 2) + pow(y, 2) - z- 5;

// hyperbola of one sheet -> hyperbola of two sheets
// function f(x, y, z) = pow(x, 2) + pow(y, 2) - pow(z, 2) - 10 + 20 * $t;

// hyperbola of two sheets
function f(x, y, z) = pow(x, 2) - pow(y, 2) - pow(z, 2) - 5;

// cone
// function f(x, y, z) = pow(x, 2) + pow(y, 2) - pow(z, 2);

// repeating connected bulbs
// function f(x, y, z) = cos(x * 180 / 3.14 * 2) + cos(y * 180 / 3.14 * 2) + cos(z * 180 / 3.14 * 2);

// repeating connected bulbs over time
// function f(x, y, z) = cos(x * 180 / 3.14 * 2) + cos(y * 180 / 3.14 * 2) + cos(z * 180 / 3.14 * 2) -3.14 + 6.28 * $t;

// Steiner's Roman Surface
// bounds of 1.05 and resolution of 0.05
// function f(x, y, z) = pow(x, 2) * pow(y, 2) + pow(y, 2) * pow(z, 2) + pow(z,2) * pow(x, 2) - 2 *  x * y * z;

edgePoints = [
  [0, 0.5, 0],
  [0.5, 1, 0],
  [1, 0.5, 0],
  [0.5, 0, 0],
  [0, 0.5, 1],
  [0.5, 1, 1],
  [1, 0.5, 1],
  [0.5, 0, 1],
  [0, 0, 0.5],
  [0, 1, 0.5],
  [1, 1, 0.5],
  [1, 0, 0.5]
];

// number = 162;

function sumVector(list, c = 0) =
 c < len(list) - 1 ?
 list[c] + sumVector(list, c + 1) 
 :
 list[c];

// TODO: calculate all points, store in memory then look up?
// would calculate each point once instead of 8 times

// + resolution?
allPointsValues = [
  for( i = [-bounds : resolution : bounds]) [
    for( j = [-bounds : resolution : bounds]) [
      for( k = [-bounds : resolution : bounds])
        f(i, j, k)
    ]
  ]
];

// numbers at each vertex
// for debugging
// for( ii = [-bounds : resolution : bounds]) {
//   for( jj = [-bounds : resolution : bounds]) {
//     for( kk = [-bounds : resolution : bounds]) {
//       echo ((ii + bounds) / resolution);
//       echo(allPointsValues[(ii + bounds) / resolution ][(jj + bounds) / resolution][(kk + bounds) / resolution]);
//       translate([ii, jj, kk]) {
//         text(text = str((allPointsValues[(ii + bounds) / resolution][(jj + bounds) / resolution][(kk + bounds) / resolution])), size = 1);
//       }
//     }
//   }
// }   

// echo("all points values");
// echo(allPointsValues);


// debugging cube
// #translate([0, -10, -10]) {
//   cube(10);
// }


// z on outer loop so only have to calculatre trianle color once per z
// maybe move this outside and store all color values before this loop
for( k = [0 : 1 : 2 * bounds / resolution - 1]) {
  // pick color of triangles
  // triangleColor = [sin((i + bounds) / bounds * 45), sin((j + bounds) / bounds * 45), sin((bounds - k) / bounds * 45)];
  
  // have 45 degrees for which each color is on
  // blue is at bottom, green in middle, red on top, like other graphs online
  // go from - bounds to bounds then divide by 2 so range is 1 then multiply number

  // hueModifier makes the colors lighter the higher the value is
  hueModifier = 0.1;

  triangleColor = [
    min(max(sin(k / bounds * resolution * 90 - 90) + hueModifier, 0), 1),
    min(max(sin(k / bounds * resolution * 90), 0) + hueModifier, 1),
    min(max(sin(k / bounds * resolution * 90 + 90) + hueModifier, 0), 1)
  ];

  for( j = [0 : 1 : 2 * bounds / resolution - 1]) {
    for( i = [0 : 1 : 2 * bounds / resolution - 1]) {
      // if (f([i, j, k]) > threshold) {
      // each of the eight points to check

      cubePoints = [
        [i, j, k],
        [i, j + 1, k],
        [i + 1, j + 1, k],
        [i + 1, j, k],
        [i, j, k + 1],
        [i, j + 1, k + 1],
        [i + 1, j + 1, k + 1],
        [i + 1, j, k + 1]
      ];
      
      // idk how else to do this
      // we need to figue which permuation of triangles we need
      // so i loop through each element in cubePoints and find if it is big enough
      // then i add the index of the element to the power of 2 to the element of
      // permutationNumberList. Then I add all the elements in the list
      // If i knew how to i would like to just loop over each element and add it
      // to a variable but openscad is dumb and idk how

      // permutationNumberList = [for (k = [0 : 1 : 7]) 
      //   f(cubePoints[k][0], cubePoints[k][1], cubePoints[k][2]) >= threshold ? pow(2, k) : 0
      // ];


      // if less than or equal to zero, then inside the surface
      permutationNumberList = [for (k = [0 : 1 : 7])
        allPointsValues[cubePoints[k][0]][cubePoints[k][1]][cubePoints[k][2]] <= 0 ? pow(2, k) : 0
      ];

      permutationNumber = sumVector(permutationNumberList);
      // for (k = [0 : 1 : 7]) {
      //   if ( f(cubePoints[k][0], cubePoints[k][1], cubePoints[k][2]) > threshold) {
      //     permutationNumber = permutationNumber + pow(k, 2);
      //     echo(permutationNumber);
      //   }
      // }

      // drawMarchingCube(permutationNumber, edgePoints, [i * resolution - bounds, j * resolution - bounds, k * resolution - bounds], resolution, triangleColor);
  
      // draw a marching cube
      currentPoints = points[permutationNumber];

      if (currentPoints) {
        position = [i * resolution - bounds, j * resolution - bounds, k * resolution - bounds];
        size = resolution;

        // linearly interpolate
        // go on each of three axes and find first point, then for second point do first points + 1
        // in axis that we are doing
        // this is jankey and complicated and the syntax in the vectors kinda sucks
        // but i think its better than writing out all tweleve permutations
        // im am still doing this several hours later
        // writing out all twelve permutations was definitely easier than what i did
        if (interpolation) {
          interpolatedEdgePoints = [
            for (l = [0 : 1 : 2]) (
              // alternate m so that we get all four sides
              for(m = [0 : 1 : 3]) (
                let (positionOne = [(l == 0) ? i : ((l == 1) ? i + m % 2 : i + (m >= 2 ? 1 : 0)), (l == 1) ? j : ((l == 0) ? j + ((m >= 2) ? 1 : 0) : j + m % 2), (l == 2) ? k : ((l == 0) ? k + m % 2 : k + (m >= 2 ? 1 : 0))])
                let (positionTwo = [positionOne[0] + ((l == 0) ? 1 : 0), positionOne[1] + ((l == 1) ? 1 : 0), positionOne[2] + ((l == 2) ? 1 : 0)])
                let (valueOne = allPointsValues[positionOne[0]][positionOne[1]][positionOne[2]])
                let (valueTwo = allPointsValues[positionTwo[0]][positionTwo[1]][positionTwo[2]])
                // if either valueOne is zero or valueTwo is zero, we want to send it into the loop
                // because the loop will interpolate to zero
                // check if two points have opposite signs because that is when there is a point on the edge
                  if ( valueOne == 0 || valueTwo == 0 || ((valueOne < 0) ? (valueTwo > 0) : (valueTwo < 0))) (
                  // this if might never be called
                  if (valueOne == valueTwo) (
                    // edgePoints[(l * 4 + m)]
                    0
                  ) else [
                    for(n = [0 : 1 : 2]) (
                      // if on axis that is changing, then do interpolation
                      if (positionTwo[n] - positionOne[n] == 1) (
                        // i derived this equation using point slope form
                        valueOne * size / (valueOne - valueTwo)
                      // if edge is in positive direction, add size
                      ) else if (positionOne[n] != [i, j, k][n]) (
                        size
                      ) else (
                        0
                      )
                    )
                  ]
                ) else (
                  // this needs parens, idk why
                  // edgePoints[(l * 4 + m)]
                  0           
                )
              )
            )
          ];
          
          // echo("start");
          // echo(allPointsValues[i][j][k]);
          // echo(allPointsValues[i + 1][j][k]);
          // echo(interpolatedEdgePoints);
          // i used the script in convert-array.js to help figure out which points go where
          // messy
          remappedInterpolatedEdgePoints = [
            interpolatedEdgePoints[4],
            interpolatedEdgePoints[2],
            interpolatedEdgePoints[5],
            interpolatedEdgePoints[0],
            interpolatedEdgePoints[6],
            interpolatedEdgePoints[3],
            interpolatedEdgePoints[7],
            interpolatedEdgePoints[1],
            interpolatedEdgePoints[8],
            interpolatedEdgePoints[9],
            interpolatedEdgePoints[11],
            interpolatedEdgePoints[10],
          ];
          //echo(interpolatedEdgePoints);

          // if (i + 2 * j + 4 * k == 1) {
          //   for(h = [0 : 1 : 11]) {
          //     if (remappedInterpolatedEdgepoints[h] != 0) {
          //       red = h<4?h/3:1;
          //       green = h>3 && h<8?(h-4)/3:1;
          //       blue = h>7?(h-8)/3:1;
          //       echo("h");
          //       echo(h);
          //       echo([red, green, blue]);
          //       translate(position) {
          //         translate(remappedInterpolatedEdgePoints[h]) {
          //           color([red, green, blue]) {
          //             sphere(1);
          //           }
          //         }
          //       }
          //     }
          //   }
          // }

          // copying and pasting code is bad but putting this in a module slows down render time
          // loop through each triangle in currentPoints and draw
          for (i = [0 : 1 : len(currentPoints) - 1]) {
            // echo("position");
            // echo(position);
            // turns the edges from currentPoints into actual points from edgePoints and multiply by size
            currentTriangle = [
              for (j = [0 : 2]) remappedInterpolatedEdgePoints[currentPoints[i][j]] + position
            ];
          
            // echo("triangle");
            // echo(currentTriangle);
            color(triangleColor) {
              polyhedron (
                points = currentTriangle,
                faces = [[0, 1, 2]]
              );
            }
          }
        } else {
          // no interpolation loop
          // loop through each triangle in currentPoints and draw
          for (i = [0 : 1 : len(currentPoints) - 1]) {
            // turns the edges from currentPoints into actual points from edgePoints and multiply by size
            currentTriangle = [
              for (j = [0 : 2]) edgePoints[currentPoints[i][j]] * size + position
            ];
            color(triangleColor) {
              polyhedron (
                points = currentTriangle,
                faces = [[0, 1, 2]]
              );
            }
          }
        }
      }
    }
  }
}

// currentPoints = points[search(number, edges)[0]];

// echo(points[search(265, edges)[0]]);
// echo(points[3]);

// function changePoints(edgePoints, points) = (
//   for(i = [0 : 1 : 2]) {
//   }
// );

// trianglePointsOnFace = points[search(265, edges)[0]];

// trianglePoints = [ for (i = [0 : 1 : len(trianglePointsOnFace)]) ]

// for (i = [0:1:len(trianlgePoints)]) {
//   for (j = [0:1:len(trianglePoints[i])]) {
//     trianglePoints[i][j] = edgePoints.trianglePoints[i][j];
//   }
// }

// polyhedron(
//   points=points[search(265, edges)[0]], 
//   faces=[ [0,1,2], [3, 4, 5], [6, 7, 8], [9, 10, 11], [12, 13, 14] ]
//  );

/**
 * loop through each point
 *  at each point find the sides for the cube
 *  render cube sides
 */
