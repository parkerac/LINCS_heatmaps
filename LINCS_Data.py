#! /bin/python
#The metadata file can be downloaded from https://byu.box.com/s/tiejucj2vm4t25n56jmogtkp9ikhbgaf
#The data file can be downloaded from https://byu.box.com/s/6pb8p26zn3wgelslurildzlo2xudurez

outputHPRT1 = open("outputHPRT1Data.tsv", "w")
outputAURKA = open("outputAURKAData.tsv", "w")

def getData(gene, outputFile):
  metaData = open("metadata.tsv")
  dataFile = open("data.tsv")
  dataDictionary = {}
  lineCount = 0

  for line in dataFile:
      lineCount += 1
      line = line.strip().split("\t")
      if lineCount == 1:
          index = line.index(gene)
      else:
          dataDictionary[line[0]] = line[index]

  metaDataDictionary = {}
  lineCount = 0
  colNames = []

  for line in metaData:
      lineCount += 1
      if lineCount == 1:
          continue
      else:
        line = line.strip().split("\t")
        if line[1] not in colNames:
            colNames.append(line[1])
        if line[0] not in metaDataDictionary:
            nestedDictionary = {}
            nestedDictionary[line[1]] = line[2]
            metaDataDictionary[line[0]] = nestedDictionary
        else:
            metaDataDictionary[line[0]][line[1]] = line[2]

  headerLine = "Sample\t"
  for item in sorted(colNames):
    headerLine += item + "\t"
  headerLine += gene + "\n"
  outputFile.write(headerLine)

  for key, value in metaDataDictionary.items():
    outputLine = key + "\t"
    for item in sorted(colNames):
        if item in value:
            outputLine += value[item] + "\t"
        else:
            outputLine += "NA\t"
    outputLine += dataDictionary[key] + "\n"
    outputFile.write(outputLine)
  metaData.close()
  dataFile.close()


getData("HPRT1", outputHPRT1)
getData("AURKA", outputAURKA)


outputHPRT1.close()
outputAURKA.close()
