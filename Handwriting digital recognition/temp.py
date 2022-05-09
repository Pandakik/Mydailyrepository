import numpy

import scipy.special

import matplotlib.pyplot

# ensure the plots are inside this notebook, not an external window 


class neuralNetwork :
        
    def __init__(self,inputnodes,hiddennodes,outputnodes,learningrate) :
        
        
        self.inodes = inputnodes
        self.hnodes = hiddennodes
        self.onodes = outputnodes
        
        self.wih = numpy.random.normal(0.0,pow(self.hnodes,-0.5),(self.hnodes,self.inodes))
        self.who = numpy.random.normal(0.0,pow(self.onodes,-0.5),(self.onodes,self.hnodes))
        
        self.lr = learningrate
        
        self.activation_function = lambda x: scipy.special.expit(x)
        pass
    
    
    def train(self,inputs_list,targets_list) :
        
        inputs = numpy.array(inputs_list,ndmin = 2).T
        targets = numpy.array(targets_list,ndmin = 2).T
        
       
        hidden_inputs = numpy.dot(self.wih, inputs) #计算隐藏层中的信号
        hidden_outputs = self.activation_function(hidden_inputs) #计算隐藏层中出现的信号

        final_inputs = numpy.dot(self.who, hidden_outputs) #将信号计算到最终输出层
        final_outputs = self.activation_function(final_inputs) #计算从最终输出层发出的信号

        output_errors = targets - final_outputs #输出层错误是（目标-实际）
        hidden_errors = numpy.dot(self.who.T, output_errors) #隐藏层错误是输出错误，按权重分割，在隐藏节点重新组合

        #更新隐藏层和输出层之间链接的权重                              
        self.who += self.lr * numpy.dot((output_errors * final_outputs * (1.0 - final_outputs)), numpy.transpose(hidden_outputs))
        #更新输入层和隐藏层之间链接的权重
        self.wih += self.lr * numpy.dot((hidden_errors * hidden_outputs * (1.0 - hidden_outputs)), numpy.transpose(inputs))
        pass
    
    #查询神经网络
    def query(self,inputs_list):
        
        #将输入列表转换为二维数组
        inputs = numpy.array(inputs_list, ndmin = 2).T
        
        hidden_inputs = numpy.dot(self.wih, inputs) #计算隐藏层中的信号
        hidden_outputs = self.activation_function(hidden_inputs) #计算隐藏层中出现的信号

        final_inputs = numpy.dot(self.who, hidden_outputs) #将信号计算到最终输出层
        final_outputs = self.activation_function(final_inputs) #计算从最终输出层发出的信号

        return final_outputs 



#输入、隐藏、输出节点数
input_nodes = 784
hidden_nodes = 100
output_nodes = 10

#学习率
learning_rate = 0.3

#创建神经网络实例
n = neuralNetwork(input_nodes,hidden_nodes,output_nodes,learning_rate)

#将文件导入列表
training_data_file = open("E:\潘宗勇的短学期\python 神经网络\8.png", 'rb') 
training_data_list = training_data_file.readlines()
training_data_file.close() 


for record in training_data_list:
    all_values = record.split(',')
    inputs = (numpy.asfarray(all_values[1:]) / 255.0 * 0.99) + 0.01
    targets = numpy.zeros(output_nodes) + 0.01   
    targets[int(all_values[0])] = 0.99 
    n.train(inputs, targets) 
    pass
    
test_data_file = open("E:\潘宗勇的短学期\python 神经网络\8.png", 'rb') 
test_data_list = test_data_file.readlines() 
test_data_file.close()

all_values = record.split(',')
print(all_values[0])    

image_array = numpy.asanyarray(all_values[1:]).reshape((28,28))
matplotlib.pyplot.imshow(image_array, cmap = 'Greys',interpolation='None')