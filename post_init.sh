#!/bin/bash

echo "Changing ownership of directories in /home/user to user:user..."
chown -R user:user /home/user

echo "Changing file permissions in /home/user/.ssh..."
chmod 600 /home/user/.ssh/*
chmod 700 /home/user/.ssh

echo "Done."