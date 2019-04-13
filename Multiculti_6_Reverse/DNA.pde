float normalizeData(float data){
 return atan(2*data) * (2/PI);
}

class neuron{
float bias;
float [] weights;

  neuron(){
    
  }
  
  
  float[] retunName(){
    float[] name;
     //println(weights.length);
    name = new float[weights.length + 2];

    for(int i = 0 ; i < weights.length; i++){
     name[i] = weights[i]; 
    }
    name[weights.length + 1] = bias;
    return name;
  }
  
  void setNames(float[] name){
    /*
    println("");
    println("");
    println(name.length);
    println(weights.length);
    println("");
    */
    for(int i = 0 ; i < name.length - 2; i++){
      //println(i);
     weights[i] = name[i]; 
    }
    bias = name[name.length-1];
  }
  
  /*
  public byte[] floatToByteArray(float value) {
    int intBits =  Float.floatToIntBits(value);
    return new byte[] {
      (byte) (intBits >> 24), (byte) (intBits >> 16), (byte) (intBits >> 8), (byte) (intBits) };
}
public float byteArrayToFloat(byte[] bytes) {
    int intBits = 
      bytes[0] << 24 | (bytes[1] & 0xFF) << 16 | (bytes[2] & 0xFF) << 8 | (bytes[3] & 0xFF);
    return Float.intBitsToFloat(intBits);  
}
*/

  void updateWeights(float [] Weights){
    weights = new float[Weights.length];
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
  /*
  float sigmoid(float input){
   return 1.0 / 1.0 + exp(-input); 
  }
  */
  
  float sigmoid(float input){
    input = input / 1000.0;
return (atan(input) / 1.0*PI) + 0.5;
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
   input = new float[inputLayer];
   
   
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

 ArrayList<float[]> retunName(){
   ArrayList<float[]> Name = new ArrayList<float[]>();   
    
   for (neuron b: Sigmoid) {
      Name.add(b.retunName());
    }
    
    for (neuron b: Linear) {
      Name.add(b.retunName());
    }
    
    for (neuron b: Output) {
      Name.add(b.retunName());
    }
    return Name;
 }
 
 void setNames(ArrayList<float[]> name){  
    int i = 0;
   for (neuron b: Sigmoid) {
      b.setNames(name.get(i));
      i++;
    }
    
    for (neuron b: Linear) {
      b.setNames(name.get(i));
      i++;
    }
    
    for (neuron b: Output) {
      b.setNames(name.get(i));
      i++;
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
      output[i] = b.sigmoid(b.output(linear));
      i++;
    }
    
    return output;
  }
  
  void mutate(int mutationFactor){
    for (neuron b: Sigmoid) {
      b.mutateBias(random(0 , mutationFactor / 100));
      for(int i = 0; i < Sigmoid.size() ; i++){
        b.mutateWeights(random(0 , mutationFactor / 100) , i);
      }
    }
    
    for (neuron b: Linear) {
      b.mutateBias(random(0 , mutationFactor / 100));
      for(int i = 0; i < Linear.size() ; i++){
        b.mutateWeights(random(0 , mutationFactor / 100) , i);
      }
    }
    
    for (neuron b: Output) {
      b.mutateBias(random(0 , mutationFactor / 100));
      for(int i = 0; i < Output.size() ; i++){
        b.mutateWeights(random(0 , mutationFactor / 100) , i);
      }
    }
    
  }
  
}
