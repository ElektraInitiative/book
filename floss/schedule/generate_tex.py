#!/usr/bin/env python3

# This script generates a LaTeX-table in the file table.tex
# based on events defined in a .ics-file.
# Additionally, some consistency checks are done
# (e.g. regarding the numer of deadlines or the effort on one day)

from dataclasses import dataclass
from datetime import date, datetime
from typing import List, TextIO
from dateutil.easter import easter
import argparse

parser = argparse.ArgumentParser(
                    prog='generate_tex',
                    description='Generate Tex table from a given calender',
                    epilog='')

parser.add_argument('filename')
parser.add_argument('-f', '--force', action='store_true')
parser.add_argument('-y', '--year')


args = parser.parse_args()
YEAR = int(args.year)
print(args.filename, args.force, YEAR)


@dataclass
class Event:
    date: datetime
    end_date: datetime
    summary: str
    location: str
    effort: float # in hours


def parse_date(line: str):
    return datetime.strptime(line, "%Y%m%dT%H%M%S")


# Read one event from the .ics-file (calendar)
# Get start-date, end-date, event title (summary) and effort (description) from the .ics-file
def read_event(file: TextIO):
    effort = 0 # default value for effort
    location = ""

    for line in file:
        # Remove last character (newline) from string
        line = line[:-1]
        if line.startswith("DTSTART;TZID=Europe/Vienna:"):
            date = parse_date(line[27:])
        if line.startswith("DTEND;TZID=Europe/Vienna:"):
            end_date = parse_date(line[25:])
        elif line.startswith("SUMMARY:"):
            summary = line[8:]
        elif line.startswith("LOCATION:"):
            location = line[9:]
        #elif line.startswith("DESCRIPTION;"): # custom description entered via Thunderbird
            # # Convert string to float, the float-number is after the last ":" character in the string
            # # Support both, "," and "." for float-numbers in the description field
            #effort = float(line.rpartition(':')[2].replace("\,", "."))
        elif line == "END:VEVENT":
            break

    return Event(date, end_date, summary, location, effort)


# Read all events from the .ics-file
def read_events(file: TextIO):
    events = []
    for line in file:
        # remove last character (newline) from string
        line = line[:-1]
        if line == "BEGIN:VEVENT": #start of an event-entry
            events.append(read_event(file))
    return events


# Group a list of event by calendar weeks
# Returns a tuple with an dictionary the first week-number and the last week-number
def group_by_week(events: List[Event]):
    events = sorted(events, key=lambda e: e.date) # sort events by date
    weeks = {} # dictionary with key=weeknumber and value=List of events for this week
    firstweek = events[0].date.isocalendar().week
    lastweek = events[-1].date.isocalendar().week

    for event in events:
        week = event.date.isocalendar().week # get week-number of the current event
        weeks[week] = weeks.get(week, []) + [event] # append current event to the list of events for this week

    return (weeks, firstweek, lastweek)

# Prepare string for usage in LaTeX-files
def latex_escape(s: str):
    # replace '\,' with ',' to support commas in event summaries
    return s.replace("&", "\&").replace("\,", ",")

# Generate LaTeX-source based on the type (event-title) of the current event
# f-strings can contain function calls (e.g. latex_escape(str)) in this case
def row_command(event: Event, includeLocation: bool):
    date = event.date.strftime(DATE_FORMAT)
    summary = event.summary
    spacePos = summary.find(" ")
    
    if includeLocation:
        location = event.location
        if summary == "Consultation Hour":
            return f"\\chour{{}}{{{date}}}{{{location}}}{{{latex_escape(summary)}}}{{}}"
        elif summary[0] == "T" and summary[1] == "U":
            return f"\\tutorial{{{latex_escape(summary[2:spacePos])}}}{{{date}}}{{{location}}}{{{latex_escape(summary[spacePos+1:])}}}{{}}"
        elif summary[0] == "M":
            return f"\\meeting{{{latex_escape(summary[1:spacePos])}}}{{{date}}}{{{location}}}{{{latex_escape(summary[spacePos+1:])}}}{{}}"
        elif summary[0] == "T":
            return f"\\team{{{latex_escape(summary[1:spacePos])}}}{{{date}}}{{{location}}}{{{latex_escape(summary[spacePos+1:])}}}{{}}"
        elif summary[0] == "H":
            return f"\\home{{{latex_escape(summary[1:spacePos])}}}{{{date}}}{{{location}}}{{{latex_escape(summary[spacePos+1:])}}}{{}}"
        elif summary[0] == "P":
            return f"\\project{{{latex_escape(summary[1:spacePos])}}}{{{date}}}{{{location}}}{{{latex_escape(summary[spacePos+1:])}}}{{}}"
        elif summary[0] == "D":
            return f"\\demo{{{latex_escape(summary[1:spacePos])}}}{{{date}}}{{{location}}}{{{latex_escape(summary[spacePos+1:])}}}{{}}"
        elif summary[0] == "W":
            return f"\\science{{}}{{{date}}}{{{latex_escape(summary)}}}{{}}"
        else:
            raise Exception(f"Unknown summary: {summary}")
    else:
        if summary == "Consultation Hour":
            return f"\\chour{{}}{{{date}}}{{{latex_escape(summary)}}}{{}}"
        elif summary[0] == "T" and summary[1] == "U":
            return f"\\tutorial{{{latex_escape(summary[2:spacePos])}}}{{{date}}}{{{latex_escape(summary[spacePos+1:])}}}{{}}"
        elif summary[0] == "M":
            return f"\\meeting{{{latex_escape(summary[1:spacePos])}}}{{{date}}}{{{latex_escape(summary[spacePos+1:])}}}{{}}"
        elif summary[0] == "T":
            return f"\\team{{{latex_escape(summary[1:spacePos])}}}{{{date}}}{{{latex_escape(summary[spacePos+1:])}}}{{}}"
        elif summary[0] == "H":
            return f"\\home{{{latex_escape(summary[1:spacePos])}}}{{{date}}}{{{latex_escape(summary[spacePos+1:])}}}{{}}"
        elif summary[0] == "P":
            return f"\\project{{{latex_escape(summary[1:spacePos])}}}{{{date}}}{{{latex_escape(summary[spacePos+1:])}}}{{}}"
        elif summary[0] == "D":
            return f"\\demo{{{latex_escape(summary[1:spacePos])}}}{{{date}}}{{{latex_escape(summary[spacePos+1:])}}}{{}}"
        elif summary[0] == "W":
            return f"\\science{{}}{{{date}}}{{{latex_escape(summary)}}}{{}}"
        else:
            raise Exception(f"Unknown summary: {summary}")

# LaTeX formatting (break and horizontal line)
def print_line(f):
    print(f" & \\\\*", file=f)
    print(f"\\hline", file=f)


# Get prefix which defines the type of the event (e.g. homework, teamwork, project) from the event title
def get_prefix(summary: str):
    # Get substring before the first ":" character
    full_prefix = summary.partition(':')[0]
    for chr in full_prefix:
        if chr.isdigit():
            # Return substring before the first digit in the title
            return full_prefix[:full_prefix.index(chr)]
    return full_prefix # no digit found


# Analyze events and print warnings if too many deadlines or too much effort is defined for the same day
def analyzeEvents(events: List[Event]):
    event_numbers = {} # Dictionary with key=date, value=number of limited events on this day
    event_efforts= {} # Dictionary with key=date, value=overall effort for deadlines on this day
    abort_processing = False
    for event in sorted(events, key=lambda e: e.date):
        if get_prefix(event.summary) in LIMITED_EVENTS: # is the current event of a type for which limits apply
            event_numbers[event.date.strftime("%d.%m.%y")] = event_numbers.get(event.date.strftime("%d.%m.%y"), 0) + 1
            event_efforts[event.date.strftime("%d.%m.%y")] = event_efforts.get(event.date.strftime("%d.%m.%y"), 0) + event.effort
            # Limited events should have same start- and end-date
            if event.date != event.end_date:
                print(f"{ERROR_COLOR}DIFFERENT START- AND ENDDATE:{COLOR_END} {event.date}-{event.summary}");
                abort_processing = True
            # Limited events should have the deadline, which should be at 23:59, as start date
            if event.date.hour != 23 or event.date.minute != 59:
                print(f"{ERROR_COLOR}DEADLINE NOT AT 23:59:{COLOR_END} {event.date}-{event.summary}");
                abort_processing = True
    # Print overview of number of events and effort for each day with deadlines
    print("### Overview of events per date: ###")
    for item in event_numbers:
        print(f"{item}: {event_numbers[item]} event{'s' if event_numbers[item] > 1 else ''}, effort: {event_efforts[item]}", end="")
        if event_numbers[item] > MAX_EVENTS:
            print(f" {WARNING_COLOR}TOO MUCH EVENTS ON THIS DAY (LIMIT IS {MAX_EVENTS}!){COLOR_END}",end="")
        if event_efforts[item] > MAX_EFFORT:
            print(f" {WARNING_COLOR}TOO MUCH EFFORT ON THIS DAY (LIMIT IS {MAX_EFFORT}!){COLOR_END}",end="")
        print("") # newline
    # Parameter "-f" forces creation of the LaTeX-table despite errors with events
    if abort_processing and not args.force:
        raise Exception("Fatal errors with events in calendar (see printed warnings)!")


# Constant definitions
DATE_FORMAT = "%d.\\,%m."
LIMITED_EVENTS = ["H", "T", "P"] # types of events with deadlines (homework, teamwork, project)
MAX_EVENTS = 3 # max. number of events on one day
MAX_EFFORT = 5 # max hours of effort that the work for all deadlines on one day should not exceed
# colored output on terminal
WARNING_COLOR = '\033[93m'
ERROR_COLOR = '\033[91m'
COLOR_END = '\033[0m' # switch back to normal uncolored output


def checkIfSummerTerm (file: TextIO):
    for line in file:
        trimmedLine = line.strip()
        if trimmedLine.startswith("\\def\\mytitle{"):
            if (trimmedLine[-2]) == 'S':
                return True
            elif (trimmedLine[-2] == 'W'):
                return False
            else:
                raise Exception("The title in schedule.tex must end with 'S' (summer term) or 'W' (winter term), but it ends with " + trimmedLine[-3] + "!")
    raise Exception ("Could not find a line with the title (= a line that starts with \"\\def\\mytitle{\")")


def checkIfIncludeLocations (file: TextIO):
    weekLineFond = False
    locationColFound = False
    for line in file:
        trimmedLine = line.strip();
        if trimmedLine.startswith("\\textbf{Week}"):
            if (weekLineFond):
                raise Exception("More than one line in schedule.tex starts with \"\\textbf{Week}\". This is not allowed!")
            weekLineFond = True
            if trimmedLine.find("Location") != -1:
                locationColFound = True
    return locationColFound


def main():
    with open(args.filename, "r") as f:
        events = read_events(f)

    analyzeEvents(events)
    weeks = group_by_week(events)
    first = True # for formatting (print line)

    summerTerm = False
    includeLocation = False

    with open("schedule.tex", "r") as f:
        summerTerm = checkIfSummerTerm(f)
        includeLocation = checkIfIncludeLocations(f)

    print ("Summer term: {}".format(summerTerm))
    print ("Location column: {}".format(includeLocation))

    with open("table.tex", "w") as  f:
        if summerTerm:
            endYear = YEAR + 1 # for current year
        else:
            endYear = YEAR + 2 # for current and next year (the winter term covers two years (January of next year)
        for y in range(YEAR, endYear): 
            if y == YEAR: # current year
                first_week = weeks[1]
                if summerTerm:
                    last_week = weeks[2]
                else:
                    # According to the ISO standard, 28th of December is  always in the last week of the year
                    last_week = date(y, 12, 28).isocalendar().week
            else: # only for winter term
                first_week = 1 # The next year in January starts with week number 1
                last_week = weeks[2]
            for w in range(first_week, last_week + 1):
                week_start = datetime.fromisocalendar(y, w, 1)
                week_end = datetime.fromisocalendar(y, w, 5)

                if w in weeks[0]: # weeks[0] is a dictionary with key=week-nubmer and value=list of events
                    week = weeks[0][w] # Get list of events for the currently processed week-number
                    first_row = row_command(week[0],includeLocation) # process first event of the currently processed week-number
                    second_row = row_command(week[1], includeLocation) if len(week) > 1 else "" # 2nd event of the week
                    extra_rows = [f"& {row_command(w, includeLocation)}" for w in week[2:]] # further events in the same week
                elif summerTerm == False and w == last_week and y == YEAR: # special case: holidays in the last week
                    print_line(f)
                    print(f"\\textbf{{{w} + {1}}}  & \\\\*", file=f)
                    if includeLocation:
                        print(f"{week_start.strftime(DATE_FORMAT)}--{datetime.fromisocalendar(y+1, 1, 5).strftime(DATE_FORMAT)} & & & \multicolumn{{2}}{{l}}{{(winter holidays)}} \\\\*", file=f)
                    else:
                        print(f"{week_start.strftime(DATE_FORMAT)}--{datetime.fromisocalendar(y+1, 1, 5).strftime(DATE_FORMAT)} & & & (winter holidays) \\\\*", file=f)
                    continue
                elif w == easter(y).isocalendar().week:
                    print_line(f)
                    print(f"\\textbf{{{w} + {1}}}  & \\\\*", file=f)
                    if includeLocation:
                        print(f"{week_start.strftime(DATE_FORMAT)}--{datetime.fromisocalendar(y, w+1, 5).strftime(DATE_FORMAT)} & & & \multicolumn{{2}}{{l}}{{(easter holidays)}} \\\\*", file=f)
                    else:
                        print(f"{week_start.strftime(DATE_FORMAT)}--{datetime.fromisocalendar(y, w+1, 5).strftime(DATE_FORMAT)} & & & (easter holidays) \\\\*", file=f)
                    continue
                elif w == 1: # holidays in the first week of the next year
                    continue
                else:
                    if includeLocation:
                        first_row = "& & \multicolumn{2}{l}{(Kein Treffen oder Deadline)}"
                    else:
                        first_row = "& & (Kein Treffen oder Deadline)"
                    second_row = ""
                    extra_rows = []

                if first:
                  first = False
                else:
                  print_line(f)
                print(f"\\textbf{{{w}}} & {first_row} \\\\*", file=f)
                print(
                    f"{week_start.strftime(DATE_FORMAT)}--{week_end.strftime(DATE_FORMAT)} & {second_row} \\\\*", file=f)
                for row in extra_rows:
                    print(f"{row} \\\\*", file=f)
            print("\\\\[1ex]", file=f) # vertical space
if __name__ == "__main__":
    main()
