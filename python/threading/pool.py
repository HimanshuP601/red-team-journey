import concurrent.futures
import time

start = time.perf_counter()

def do_something(s):
    print(f"Sleeping for {s} second(s)....")
    time.sleep(s)
    return f'Done Sleeping...{s}'


with concurrent.futures.ThreadPoolExecutor() as executor:
    secs = [5,4,3,2,1]
    results = [executor.submit(do_something,s) for s in secs]

    for f in concurrent.futures.as_completed(results):
        print(f.result())

finish = time.perf_counter()

print(f"Completed in {round(finish-start , 2)} second(s).")
