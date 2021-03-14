def returnNumberOfMachines(arr):
    sorted_process_times = sorted(arr, key=lambda tup: tup[0])
    lastExecTimes=[0]
    for item in sorted_process_times:
        if item[0]<min(lastExecTimes):
            lastExecTimes.append(item[1])
        else:
            lastExecTimes[lastExecTimes.index(min(lastExecTimes))]=item[1]
    return len(lastExecTimes)
 
arr=[[17,18],[20,25],[0,3],[0,2],[1,2],[3,4],[15,16],[15,19]]
print(returnNumberOfMachines(arr))
    