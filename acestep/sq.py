from functools import wraps
import requests

sq_url = None

def sq(func):
    @wraps(func)
    def wrap(*orig_args, **kwargs):
        try:
            if sq_url:
                requests.post(sq_url + "/acestep15/join", timeout=3600)
            return func(*orig_args, **kwargs)
        finally:
            if sq_url:
                requests.post(sq_url + "/acestep15/leave", timeout=5)

    return wrap
