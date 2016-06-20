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

PVector intersection(PVector v1, PVector v2) {
  double d = cos(v2.y) * sin(v1.y) - cos(v1.y) * sin(v2.y);
  float x = (float) (( v2.x*sin(v1.y) - v1.x*sin(v2.y))/d)/2;
  float y = (float) ((-v2.x*cos(v1.y) + v1.x*cos(v2.y))/d)/2;
  return new PVector(x, y);
}


List<PVector> hough(PImage edgeImg, int nLines) {


  List<PVector> corners = new ArrayList();

  float discretizationStepsPhi = 0.07f;
  float discretizationStepsR = 1.0f;
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

  imgproc.stroke(255, 165, 0);
  imgproc.strokeWeight(4);

  for (int i = 0; i < bestCandidates.size() && i<nLines; i++) {
    int idx = bestCandidates.get(i);
    // first, compute back the (r, phi) polar coordinates:
    int accPhi = (int) (idx / (rDim + 2)) - 1;
    int accR = idx - (accPhi + 1) * (rDim + 2) - 1;
    float r = (accR - (rDim - 1) * 0.5f) * discretizationStepsR;
    float phi = accPhi * discretizationStepsPhi;
    bestLines.add(new PVector(r, phi));
  }

  QuadGraph quadGraph = new QuadGraph();
  quadGraph.build(bestLines, edgeImg.width, edgeImg.height);
  List<int[]> quads = quadGraph.findCycles();
  double bestError = Double.POSITIVE_INFINITY;
  boolean goodQuadFound = false;
  PVector bestc12= new PVector();
  PVector bestc23= new PVector();
  PVector bestc34= new PVector();
  PVector bestc41= new PVector();
  for (int i = 0; i<quads.size(); i++) {
    PVector l1 = bestLines.get(quads.get(i)[0]);
    PVector l2 = bestLines.get(quads.get(i)[1]);
    PVector l3 = bestLines.get(quads.get(i)[2]);
    PVector l4 = bestLines.get(quads.get(i)[3]);

    PVector c12 = intersection(l1, l2);
    PVector c23 = intersection(l2, l3);
    PVector c34 = intersection(l3, l4);
    PVector c41 = intersection(l4, l1);

    if (goodQuad(quadGraph, c12, c23, c34, c41)) {

      c12.mult(2);
      c23.mult(2);
      c34.mult(2);
      c41.mult(2);

      goodQuadFound = true;


      double parallelError = 0.0;
      float diff = abs(bestLines.get(quads.get(i)[0]).y - bestLines.get(quads.get(i)[2]).y);
      parallelError += min(diff, abs(diff-PI));
      diff = abs(bestLines.get(quads.get(i)[1]).y - bestLines.get(quads.get(i)[3]).y);
      parallelError += min(diff, abs(diff-PI));
      if (bestError>parallelError) {
        bestc12=c12;
        bestc23=c23;
        bestc34=c34;
        bestc41=c41;
        bestError = parallelError;
      }
    }
  }
  Random random = new Random();
  imgproc.stroke(0, 0, 255);
  imgproc.fill(color(min(255, random.nextInt(300)), 
    min(255, random.nextInt(300)), 
    min(255, random.nextInt(300)), 50));
  imgproc.quad(bestc12.x, bestc12.y, bestc23.x, bestc23.y, bestc34.x, bestc34.y, bestc41.x, bestc41.y);

  if (goodQuadFound) {
    corners.add(bestc12);
    corners.add(bestc23);
    corners.add(bestc34);
    corners.add(bestc41);
  }


  return corners;
}

boolean goodQuad(QuadGraph quadGraph, PVector c1, PVector c2, PVector c3, PVector c4) {
  return (quadGraph.nonFlatQuad(c1, c2, c3, c4)) &&
    (quadGraph.isConvex(c1, c2, c3, c4)) &&
    (quadGraph.validArea(c1, c2, c3, c4, MAX_QUAD_AREA, MIN_QUAD_AREA));
}