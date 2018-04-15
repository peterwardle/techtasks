# Tech Tasks: Housekeeping

## Assumptions

    - Application logs are stored in a single directory, that only contains the application logs to be managed
    - Application creates only a single, daily log file
    - Each log file is uniquely named but cannot be relied upon for accuracy/convention/structure
    - The preference is to store as many logs as possible within the parameters of the system (storage)
    - Staying within the defined storage bounds is more important than any data that will be lost from removal of log files
    - Initial "deployment" will be manual, but should not require any further user interaction after that point

## Solution

I've chosen to use Python over Bash in this instance, predominantly for its greater portability between different systems. Also for its convenient standard library that includes all necessary libraries/tools I felt I required.

I've also chosen Puppet over Ansible, which I'd initial considered for reduced system dependencies, both for running and initial "deployment". However, due to the need for this to be ran by the system without manual input, I decided to use Puppet in combination with a platform specific script (Bash) for the initial "deployment".

You'll notice I've also used Make and Docker; this is not a dependency for the use of the solution, this was purely to aid development/testing locally.
