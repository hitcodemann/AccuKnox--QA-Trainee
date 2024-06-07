#!/usr/bin/env python3

import re
from collections import Counter

LOG_FILE = 'web_server.log'
REPORT_FILE = 'log_report.txt'

def parse_log_line(line):
    pattern = re.compile(r'(?P<ip>\d+\.\d+\.\d+\.\d+) - - \[(?P<date>.*?)\] "(?P<method>GET|POST) (?P<url>\S+).*" (?P<status>\d+) .*')
    match = pattern.match(line)
    if match:
        return match.groupdict()
    return None

def analyze_logs(log_file):
    with open(log_file, 'r') as f:
        logs = f.readlines()

    ip_counter = Counter()
    url_counter = Counter()
    status_counter = Counter()

    for log in logs:
        parsed_log = parse_log_line(log)
        if parsed_log:
            ip_counter[parsed_log['ip']] += 1
            url_counter[parsed_log['url']] += 1
            status_counter[parsed_log['status']] += 1

    return ip_counter, url_counter, status_counter

def generate_report(ip_counter, url_counter, status_counter, report_file):
    with open(report_file, 'w') as f:
        f.write("Log File Analysis Report\n")
        f.write("========================\n\n")
        
        f.write("Top 10 IP Addresses:\n")
        for ip, count in ip_counter.most_common(10):
            f.write(f"{ip}: {count} requests\n")
        
        f.write("\nTop 10 Requested Pages:\n")
        for url, count in url_counter.most_common(10):
            f.write(f"{url}: {count} requests\n")

        f.write("\nHTTP Status Codes:\n")
        for status, count in status_counter.items():
            f.write(f"{status}: {count} responses\n")
        
        f.write("\n404 Errors:\n")
        f.write(f"Total 404 Errors: {status_counter.get('404', 0)}\n")

def main():
    ip_counter, url_counter, status_counter = analyze_logs(LOG_FILE)
    generate_report(ip_counter, url_counter, status_counter, REPORT_FILE)
    print(f"Log analysis report generated: {REPORT_FILE}")

if __name__ == "__main__":
    main()
