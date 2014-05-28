#!/usr/bin/env python

import time
import subprocess

class Job:
    def __init__(self, job):
        # Initialize something
        self.job = job 

    def run(self):
        while True:
            self.execute()
            time.sleep(60 * 15)

    def execute(self):
        subprocess.call(self.job, shell=False)

if __name__ == "__main__":
    job = Job("./check-incoming.sh")
    job.run()
