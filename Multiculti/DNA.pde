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
  
  void mutateWeights(float  Weights , int i){
     weights[i] += Weights;
  }
  
  void updateBias(float Bias){
   bias = Bias; 
  }
  
  void mutateBias(float Bias){
   bias += Bias; 
  }
  
  float output(float[] previousLayer){
    float result = 0;
    for (int i = 0; i < previousLayer.length; i++) {
      result += (previousLayer[i] + bias) * weights[i];
    }
    return result;
  }
  
  float sigmoid(float input){
   return 1 / 1 + exp(-input); 
  }
  
  float Relu(float input){
   if(input > 0){
     return input;
   }else{
     return 0;
   }
  }
}


class brain{
  ArrayList<neuron> Sigmoid = new ArrayList<neuron>();
  ArrayList<neuron> Linear = new ArrayList<neuron>();
  ArrayList<neuron> Output = new ArrayList<neuron>();
  float[] input;
  
 brain( int inputLayer ,int firstLayer , int secondLayer , int outPutLayer){
   Sigmoid = new ArrayList<neuron>();
   Linear = new ArrayList<neuron>();
   
   
   for(int i =0 ; i < firstLayer; i++){
     neuron p = new neuron();
     Sigmoid.add(p);
   }
   
   for(int i =0 ; i < secondLayer; i++){
     neuron p = new neuron();
     Linear.add(p);
   }
   
   for(int i =0 ; i < outPutLayer; i++){
     neuron p = new neuron();
     Output.add(p);
   }
   
   for(int i =0 ; i < inputLayer; i++){
     input[i] = 0;
   }
 }
  
  void generateRandomStart(){
    for (neuron b: Sigmoid) {
     b.updateBias(random(0 , 1));
     
     float[] randomTable = new float[input.length];
     for(int i = 0 ; i < input.length ; i++){
       randomTable[i] = random(0 , 10);
     }
     b.updateWeights(randomTable);
    }
    
    for (neuron b: Linear) {
     b.updateBias(random(0 , 1));
     
     float[] randomTable = new float[Sigmoid.size()];
     for(int i = 0 ; i < Sigmoid.size() ; i++){
       randomTable[i] = random(0 , 10);
     }
     b.updateWeights(randomTable);
    }
    
    for (neuron b: Output) {
     b.updateBias(random(0 , 1));
     
     float[] randomTable = new float[Linear.size()];
     for(int i = 0 ; i < Linear.size() ; i++){
       randomTable[i] = random(0 , 10);
     }
     b.updateWeights(randomTable);
    }
    
  }
  
  float[] returnResult(float[] input){
    float[] output = new float[Output.size()];
    float[] sigmoid = new float[Sigmoid.size()];
    float[] linear = new float[Linear.size()];

    int i = 0;
    for (neuron b: Sigmoid) {
      sigmoid[i] = b.sigmoid(b.output(input));
      i++;
    }
    
    i = 0;
    for (neuron b: Linear) {
      linear[i] = b.Relu(b.output(sigmoid));
      i++;
    }
    
    i = 0;
    for (neuron b: Output) {
      output[i] = b.Relu(b.output(linear));
      i++;
    }
    
    return output;
  }
  
  void mutate(int mutationFactor){
    for (neuron b: Sigmoid) {
      b.mutateBias(random(0 , mutationFactor / 100));
      for(int i = 0; i <= Sigmoid.size() ; i++){
        b.mutateWeights(random(0 , mutationFactor / 100) , i);
      }
    }
    
    for (neuron b: Linear) {
      b.mutateBias(random(0 , mutationFactor / 100));
      for(int i = 0; i <= Linear.size() ; i++){
        b.mutateWeights(random(0 , mutationFactor / 100) , i);
      }
    }
    
    for (neuron b: Output) {
      b.mutateBias(random(0 , mutationFactor / 100));
      for(int i = 0; i <= Output.size() ; i++){
        b.mutateWeights(random(0 , mutationFactor / 100) , i);
      }
    }
    
  }
  
}
