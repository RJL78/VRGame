import java.util.Collections;
import java.util.List;
import java.util.Random;




class HoughComparator implements java.util.Comparator<Integer> {
  int[] accumulator;
  public HoughComparator(int[] accumulator) {
    this.accumulator = accumulator;
  }
  @Override
    public int compare(Integer l1, Integer l2) {
    if (accumulator[l1] > accumulator[l2]
      || (accumulator[l1] == accumulator[l2] && l1 < l2)) return -1;
    return 1;
  }
}

ArrayList<PVector> getIntersections( List<PVector> lines) {
  ArrayList<PVector> intersections = new ArrayList<PVector>();
  for (int i = 0; i < lines.size() - 1; i++) {
    PVector line1 = lines.get(i);
    for (int j = i + 1; j < lines.size(); j++) {
      PVector line2 = lines.get(j);
      // compute the intersection and add it to ’intersections’
      PVector intersectionPoint = intersection(line1, line2);
      intersections.add(intersectionPoint);
      // draw the intersection;
      fill(255, 128, 0);
      ellipse(intersectionPoint.x, intersectionPoint.y, 10, 10);
    }
  }
  return intersections;
}

PVector intersection(PVector v1, PVector v2) {
  double d = cos(v2.y) * sin(v1.y) - cos(v1.y) * sin(v2.y);
  float x = (float) (( v2.x*sin(v1.y) - v1.x*sin(v2.y))/d)/2;
  float y = (float) ((-v2.x*cos(v1.y) + v1.x*cos(v2.y))/d)/2;
  return new PVector(x, y);
}


void hough(PImage edgeImg, int nLines) {

  float discretizationStepsPhi = 0.06f;
  float discretizationStepsR = 2.5f;
  ArrayList<Integer> bestCandidates = new ArrayList();
  ArrayList<PVector> bestLines = new ArrayList();

  // dimensions of the accumulator
  int phiDim = (int) (Math.PI / discretizationStepsPhi);
  int rDim = (int) (((edgeImg.width + edgeImg.height) * 2 + 1) / discretizationStepsR);

  // our accumulator (with a 1 pix margin around)
  int[] accumulator = new int[(phiDim + 2) * (rDim + 2)];

  float[] tabSin = new float[phiDim];
  float[] tabCos = new float[phiDim];
  float ang = 0;


  for (int accPhi = 0; accPhi < phiDim; ang += discretizationStepsPhi, accPhi++) {
    // we can also pre-multiply by (1/discretizationStepsR) since we need it in the Hough loop
    tabSin[accPhi] = (float) (Math.sin(ang) );
    tabCos[accPhi] = (float) (Math.cos(ang) );
  }

  // Fill the accumulator: on edge points (ie, white pixels of the edge
  // image), store all possible (r, phi) pairs describing lines going
  // through the point.
  for (int y = 0; y < edgeImg.height; y++) {
    for (int x = 0; x < edgeImg.width; x++) {

      // Are we on an edge?
      if (brightness(edgeImg.pixels[y * edgeImg.width + x]) != 0) {
        for (int phi=0; phi<phiDim; phi++) {
          int r = (int) ((x*tabCos[phi] + y*tabSin[phi])/discretizationStepsR);
          r+= (rDim - 1)/2;
          accumulator[(phi+1)*(rDim+2) + (r+1)]++;
        }
      }
    }
  }

  for (int accR = 0; accR < rDim; accR++) {
    for (int accPhi = 0; accPhi < phiDim; accPhi++) {
      // compute current index in the accumulator
      int idx = (accPhi + 1) * (rDim + 2) + accR + 1;
      if (accumulator[idx] > MIN_VOTES) {
        boolean bestCandidate=true;
        // iterate over the neighbourhood
        for (int dPhi=-NEIGHBOURHOOD/2; dPhi < NEIGHBOURHOOD/2+1; dPhi++) {
          // check we are not outside the image
          if ( accPhi+dPhi < 0 || accPhi+dPhi >= phiDim) continue;
          for (int dR=-NEIGHBOURHOOD/2; dR < NEIGHBOURHOOD/2 +1; dR++) {
            // check we are not outside the image
            if (accR+dR < 0 || accR+dR >= rDim) continue;
            int neighbourIdx = (accPhi + dPhi + 1) * (rDim + 2) + accR + dR + 1;
            if (accumulator[idx] < accumulator[neighbourIdx]) {
              // the current idx is not a local maximum!
              bestCandidate=false;
              break;
            }
          }
          if (!bestCandidate) break;
        }
        if (bestCandidate) {
          // the current idx *is* a local maximum
          bestCandidates.add(idx);
        }
      }
    }
  }

  Collections.sort(bestCandidates, new HoughComparator(accumulator));



  //Visualizing hough image
  PImage houghImg = createImage(rDim + 2, phiDim + 2, ALPHA);
  for (int i = 0; i < accumulator.length; i++) {
    houghImg.pixels[i] = color(min(255, accumulator[i]));
  }
  //You may want to resize the accumulator to make it easier to see:
  houghImg.resize(800, 800);
  houghImg.updatePixels();

  image(houghImg, edgeImg.width, 0);
  //return houghImg;

  //showing lines
  for (int i = 0; i < bestCandidates.size() && i<nLines; i++) {

    int idx = bestCandidates.get(i);
    // first, compute back the (r, phi) polar coordinates:
    int accPhi = (int) (idx / (rDim + 2)) - 1;
    int accR = idx - (accPhi + 1) * (rDim + 2) - 1;
    float r = (accR - (rDim - 1) * 0.5f) * discretizationStepsR;
    float phi = accPhi * discretizationStepsPhi;
    bestLines.add(new PVector(r, phi));
    // Cartesian equation of a line: y = ax + b
    // in polar, y = (-cos(phi)/sin(phi))x + (r/sin(phi))
    // => y = 0 : x = r / cos(phi)
    // => x = 0 : y = r / sin(phi)
    // compute the intersection of this line with the 4 borders of
    // the image
    int x0 = 0;
    int y0 = (int) (r/tabSin[accPhi]);
    int x1 = (int) (r/tabCos[accPhi]);
    int y1 = 0;
    int x2 = edgeImg.width;
    int y2 = (int) ( -tabCos[accPhi] / tabSin[accPhi] * x2 + r/ tabSin[accPhi]);
    int y3 = edgeImg.width;
    int x3 = (int) ( -(y3 - r / tabSin[accPhi]) * (tabSin[accPhi] / tabCos[accPhi]));

    // Finally, plot the lines
    stroke(204, 102, 0);
     if (y0 > 0) {
      if (x1 > 0)
        line(x0/2, y0/2, x1/2, y1/2);
      else if (y2 > 0)
        line(x0/2, y0/2, x2/2, y2/2);
      else
        line(x0/2, y0/2, x3/2, y3/2);
    } else {
      if (x1 > 0) {
        if (y2 > 0)
          line(x1/2, y1/2, x2/2, y2/2);
        else
          line(x1/2, y1/2, x3/2, y3/2);
      } else
        line(x2/2, y2/2, x3/2, y3/2);
    }
  }

  //Building Quad Graph
  QuadGraph quadGraph = new QuadGraph();
  quadGraph.build(bestLines, edgeImg.width, edgeImg.height);
  
  
  List<int[]> quads = quadGraph.findCycles();
  boolean bestQuadFound = false;
  for (int[] quad : quads) {
    
    PVector l1 = bestLines.get(quad[0]);
    PVector l2 = bestLines.get(quad[1]);
    PVector l3 = bestLines.get(quad[2]);
    PVector l4 = bestLines.get(quad[3]);
   
    PVector c12 = intersection(l1, l2);
    PVector c23 = intersection(l2, l3);
    PVector c34 = intersection(l3, l4);
    PVector c41 = intersection(l4, l1);
    
    if (goodQuad(quadGraph, c12, c23, c34, c41) && !bestQuadFound) {
      bestQuadFound = true;
      
      
      // Choose a random, semi-transparent colour
  
    }
  }

  //showing intersections; 
  getIntersections(bestLines);
}

boolean goodQuad(QuadGraph quadGraph, PVector c1, PVector c2, PVector c3, PVector c4) {
  return (quadGraph.nonFlatQuad(c1, c2, c3, c4)) &&
    (quadGraph.isConvex(c1, c2, c3, c4)) &&
    (quadGraph.validArea(c1, c2, c3, c4, MAX_QUAD_AREA, MIN_QUAD_AREA));
}