float normalizeData(float data){
 return atan(2*data) * (2/PI);
}

class neuron{
float bias;
float [] weights;

  neuron(){

  }
  
  void updateWeights(float [] Weights){
    for (int i = 0; i < Weights.length; i++) {
      weights[i] = Weights[i];
    }
  }
  
  void updateBias(float Bias){
   bias = Bias; 
  }
  
  float output(float[] previousLayer){
    float result = 0;
    for (int i = 0; i < previousLayer.length; i++) {
      result += (previousLayer[i] + bias) * weights[i];
    }
    return result;
  }
}