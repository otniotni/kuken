#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define N 7000

typedef struct node{
  int val,max; // val is the value of the triangle and index [i,j] and
               // max is the maximum sum one can get by traversing downwards in
               // the triangle from [i,j]
} node;

void maxOfChildren(node **arr,int a, int l) {
  int max1 = arr[a+1][l].max;
  int max2 = arr[a+1][l+1].max*(l<(N-1));
  if(max1 > max2) {
    arr[a][l].max = arr[a][l].val+max1;
  }
  else {
    arr[a][l].max = arr[a][l].val+max2;
  }
  return;
}

void maxPathFromNode(node **arr,int a, int l) {
  if(a == (N-1)) { // Call back if at the bottom
    arr[a][l].max = arr[a][l].val;
    return;
  }
  if(arr[a][l].max) { // Call back if all the children of this node are already
                      // calculated
    return;
  }
  maxPathFromNode(arr,a+1,l); // Traverse down-left
  if(l < (N-1)) {
    maxPathFromNode(arr,a+1,l+1); // If not at right edge, traverse down-right
  }
  maxOfChildren(arr,a,l); // Find maximum sum of children and set to .max
}

int main(void) {
  clock_t begin = clock();
  // Read triangle from file
  FILE *fp;
  fp = fopen("pathsum.txt","r");
  // Allocate node, set .val to triangle-values and .max to zero
  node **arr;
  arr = (node**)malloc(100000*sizeof(node));
  for(int i = 0; i < N; i++) {
    arr[i] = malloc(2*100000*sizeof(node));
    for(int j = 0; j < (i+1); j++) {
      fscanf(fp,"%d",&arr[i][j].val);
      arr[i][j].max = 0;
    }
  }
  maxPathFromNode(arr,0,0);
  clock_t end = clock();
  printf("The time is: %f\n", (double)(end-begin)/CLOCKS_PER_SEC);
  printf("max: %d",arr[0][0].max);
  free(fp);
  free(arr);
  return 0;
}
