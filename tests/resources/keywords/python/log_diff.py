from robot.api.deco import keyword

@keyword
def extract_new_log_lines(after_lines, before_lines):
    """
    Vergleicht zwei Listen und gibt neue Zeilen zurück
    """

    new_lines = [line for line in after_lines if line not in before_lines]
    return new_lines
