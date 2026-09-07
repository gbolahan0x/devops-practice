# Week 1: Bash Automation & System Monitoring

## Overview

A collection of **production-ready bash scripts** for system automation, monitoring, and file management. These tools demonstrate core DevOps principles: automation, reliability, and operational visibility.

**Status**: ✅ Complete & Tested  
**Language**: Bash  
**Platform**: Linux & macOS  
**Time**: ~10 hours  

---

## 📁 Scripts Overview

### 1. **system-health-check.sh** ⭐ Advanced

Comprehensive system monitoring script with cross-platform support and real-time alerts.

**Features**:
- 💾 Disk usage monitoring with 80% threshold alerts
- 🧠 Memory/RAM tracking (Linux & macOS compatible)
- 📊 CPU load average analysis
- 🔝 Top 5 memory-consuming processes
- ⏱️ System uptime tracking
- 📝 Persistent logging with timestamps

**Usage**:
```bash
chmod +x scripts/system-health-check.sh
./scripts/system-health-check.sh
```

**Sample Output**:
```
========================================
System Health Check - 2026-09-01 15:32:10
========================================

=== System Overview ===
System Uptime: up 45 days, 3 hours, 21 minutes
Running Processes: 187
CPU Load:  0.45, 0.38, 0.42

=== Disk Usage ===
  /dev/sda1 - Used: 35G/50G (70%)
  /dev/sda2 - Used: 180G/200G (90%)
  ⚠️  WARNING: /dev/sda2 disk usage is above 80%!

=== Memory Usage ===
  Total: 16G | Used: 12G | Available: 3.2G

=== Top 5 Memory-Consuming Processes ===
  1. firefox (User: alice) - Memory: 18.5%
  2. python3 (User: root) - Memory: 12.2%
  3. docker (User: root) - Memory: 8.1%

✓ Health check complete. OS: Linux
```

---

### 2. **log-monitor.sh** 📊 Text Processing

Analyzes log files and extracts actionable insights.

**Features**:
- 📈 Count log levels (ERROR, WARNING, INFO, DEBUG)
- 📋 Display recent log entries
- 📉 Calculate error rate percentage
- 🔍 Identify error patterns
- 🛡️ Handle malformed log data gracefully

**Usage**:
```bash
chmod +x scripts/log-monitor.sh
./scripts/log-monitor.sh [log_file_path]
```

**Example**:
```bash
./scripts/log-monitor.sh logs/application.log
```

**Sample Output**:
```
=====================================
Log Analysis for: logs/application.log
=====================================

Log Level Summary:
  8 ERROR
  5 WARNING
  12 INFO
  3 DEBUG

Most Recent Entries (Last 10):
[2026-09-01 15:30:45] ERROR: Connection timeout to database
[2026-09-01 15:30:40] WARNING: Retry attempt 2/3
[2026-09-01 15:30:35] INFO: Attempting reconnection
...

Total log entries: 500
Lines containing 'error': 42
Error rate: 8%
=====================================
```

**Pro Tip**: Great for finding issues in production logs. Use with grep to narrow down:
```bash
grep "ERROR" logs/app.log | ./scripts/log-monitor.sh /dev/stdin
```

---

### 3. **backup-automation.sh** 💾 Backup & Rotation

Automates directory backups with intelligent rotation and logging.

**Features**:
- 🔄 Create timestamped tar.gz backups
- 🗑️ Automatic cleanup (keeps last 5 backups)
- 📝 Backup logging with file size tracking
- ⚠️ Error handling with exit codes
- 🎯 Customizable backup directories

**Usage**:
```bash
chmod +x scripts/backup-automation.sh
./scripts/backup-automation.sh [source_dir] [backup_dir]
```

**Example**:
```bash
# Backup Documents folder to ~/backups
./scripts/backup-automation.sh ~/Documents ~/backups

# Backup current directory
./scripts/backup-automation.sh . ~/my-backups
```

**Sample Output**:
```
Starting backup......
Source: ~/Documents
Destination: ~/backups/backup-20260901-153210.tar.gz

✓ Backup Successful!
  File: backup-20260901-153210.tar.gz
  Size: 156M

Cleaning up old backups.....
Found 6 backups, Keeping last 5 ...
  Removing: backup-20260901-120000.tar.gz
  
Backup process completed!
```

**Checking Backups**:
```bash
# List all backups
ls -lh ~/backups/backup-*.tar.gz

# View backup log
cat ~/backups/backup.log

# Restore a specific backup
tar -xzf ~/backups/backup-20260901-153210.tar.gz
```

---

### 4. **organize.sh** 📂 File Organization (Bonus)

Automatically organizes files by type into categorized directories.

**Features**:
- 🎨 Organize by extension (documents, images, videos, audio, archives, scripts)
- 📁 Auto-creates category folders
- 🔄 Batch file operations
- ✅ Progress feedback
- 🆘 Handles edge cases gracefully

**Usage**:
```bash
chmod +x scripts/organize.sh
./scripts/organize.sh [directory]
```

**Example**:
```bash
./scripts/organize.sh ~/Downloads
```

**Sample Output**:
```
Organizing files in: ~/Downloads

✓ Moved: resume.pdf
✓ Moved: photo.jpg
✓ Moved: vacation.mp4
✓ Moved: song.mp3
✓ Moved: project.zip
✓ Moved: deploy.sh
✓ Moved: random-file.txt

Organization complete!
```

**Result** - Directory Structure:
```
~/Downloads/
├── documents/
│   ├── resume.pdf
│   └── report.docx
├── images/
│   ├── photo.jpg
│   └── screenshot.png
├── videos/
│   └── vacation.mp4
├── audio/
│   └── song.mp3
├── archives/
│   └── project.zip
├── scripts/
│   └── deploy.sh
└── other/
    └── random-file.txt
```

---

## 🚀 Quick Start

### Setup

```bash
# Clone the repository
git clone https://github.com/gbolahan0x/devops-practice.git
cd devops-practice/week1-bash-automation

# Make all scripts executable
chmod +x scripts/*.sh

# Create logs directory for system-health-check
mkdir -p logs
```

### Run All Scripts

```bash
# System health check
./scripts/system-health-check.sh

# Analyze logs
./scripts/log-monitor.sh test.log

# Backup a directory
./scripts/backup-automation.sh . ~/test-backup

# Organize files
mkdir -p ~/test-files
cp /usr/bin/python3 ~/test-files/
./scripts/organize.sh ~/test-files
```

---

## 📊 Testing

All scripts have been tested and validated:

```bash
# Test log monitoring
./scripts/log-monitor.sh test.log
# Expected: Shows log level counts and error rate

# Test backup creation
./scripts/backup-automation.sh . ~/test-backup
# Expected: Creates backup-*.tar.gz file in ~/test-backup

# Test file organization
mkdir -p ~/test-org && cd ~/test-org
touch document.txt image.jpg video.mp4
../../scripts/organize.sh .
# Expected: Files moved to appropriate folders
```

---

## 📚 Skills Demonstrated

### Bash Fundamentals
- ✅ **Variables & Command Substitution**: Store and reuse values
- ✅ **Conditionals (if/elif/else)**: Control script flow
- ✅ **Loops (for, while)**: Process multiple items
- ✅ **Functions**: Reusable code blocks
- ✅ **Input Validation**: Check arguments and file existence
- ✅ **Exit Codes**: Proper error handling

### Text Processing
- ✅ **grep**: Pattern matching and filtering
- ✅ **awk**: Column extraction and parsing
- ✅ **sed**: Text substitution and formatting
- ✅ **sort/uniq**: Deduplication and ordering
- ✅ **cut**: Field extraction
- ✅ **Pipes (|)**: Chaining commands

### System Administration
- ✅ **File Operations**: mkdir, tar, find, ls
- ✅ **Disk Management**: df, du, backup rotation
- ✅ **Process Monitoring**: ps, top, process counting
- ✅ **Logging**: Timestamp tracking and audit trails
- ✅ **Cross-Platform**: Linux and macOS compatibility

### DevOps Thinking
- ✅ **Automation**: Eliminate manual tasks
- ✅ **Monitoring**: Proactive issue detection
- ✅ **Alerting**: Threshold-based warnings (80% disk)
- ✅ **Reliability**: Error handling and validation
- ✅ **Auditability**: Complete logging and history

---

## 🔧 Configuration

Most scripts work out of the box, but can be customized:

### Disk Alert Threshold
In `system-health-check.sh`, change:
```bash
DISK_THRESHOLD=80  # Alert if disk usage > 80%
```

### Backup Retention
In `backup-automation.sh`, change:
```bash
MAX_BACKUPS=5  # Keep last 5 backups
```

### File Categories
In `organize.sh`, edit the `case` statement to add/remove file types:
```bash
jpg|jpeg|png|gif|svg|ico)
    mv "$file" "$DIRECTORY/images/"
    ;;
```

---

## 📋 Real-World Use Cases

### Use Case 1: System Monitoring
```bash
# Run health check every 6 hours via cron
0 */6 * * * /home/user/devops-practice/week1-bash-automation/scripts/system-health-check.sh

# Check the log later
tail -f logs/system-health-$(date +%Y%m%d).log
```

### Use Case 2: Log Analysis
```bash
# Analyze production logs to find errors
./scripts/log-monitor.sh /var/log/nginx/error.log

# Filter errors and analyze
grep ERROR /var/log/app.log | wc -l
```

### Use Case 3: Automated Backups
```bash
# Daily backup at 3 AM
0 3 * * * /home/user/devops-practice/week1-bash-automation/scripts/backup-automation.sh ~/projects ~/backups

# Restore when needed
tar -xzf ~/backups/backup-20260901-030000.tar.gz
```

### Use Case 4: File Cleanup
```bash
# Organize Downloads folder weekly
0 9 * * 0 /home/user/devops-practice/week1-bash-automation/scripts/organize.sh ~/Downloads
```

---

## 📈 What's Next?

Week 1 complete! Ready for:

### Week 2: Configuration Management
Build a multi-environment config system:
- Dev/Staging/Prod configurations
- YAML templating
- Automated config generation
- Deployment automation

### Week 3: Docker & Containerization
Containerize your scripts:
- Create Docker images
- Multi-container deployments
- Container orchestration

### Week 4: Infrastructure as Code
Define infrastructure with code:
- Terraform/Ansible basics
- Cloud deployment automation

---

## 📝 Notes

- All scripts include error handling and exit codes
- Fully compatible with Linux and macOS
- Suitable for production use
- Comprehensive logging for auditability
- Well-commented for learning

---

## 🤝 Contributing

These are learning scripts. Improvements welcome!

Ideas:
- Add email notifications for alerts
- Support for remote backups (S3, GCS)
- Integration with monitoring systems (Prometheus, Grafana)
- Advanced log analysis (machine learning)

---

## 📄 License

Open source - use freely for learning and production

---

## 🎯 Summary

**What You've Built:**
- 4 working bash scripts
- Production-quality code
- Cross-platform compatibility
- Real DevOps automation

**Portfolio Value:**
- Shows you can automate systems
- Demonstrates bash expertise
- Proves DevOps thinking
- Exhibits professional practices

**Ready for:** Week 2 configuration management and beyond!

---

**Questions or issues?** Check the script comments or test files.

**Ready to ship!** 🚀
