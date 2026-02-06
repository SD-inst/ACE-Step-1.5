from functools import wraps
import requests
import threading

sq_url = None

# Thread-local storage for recursion depth
_thread_local = threading.local()


def sq(func):
    @wraps(func)
    def wrap(*orig_args, **kwargs):
        try:
            if not hasattr(_thread_local, 'depth'):
                _thread_local.depth = 0
            _thread_local.depth += 1

            if sq_url:
                requests.post(sq_url + "/acestep15/join", timeout=3600)
            return func(*orig_args, **kwargs)
        finally:
            if sq_url and _thread_local.depth <= 1:
                requests.post(sq_url + "/acestep15/leave", timeout=5)
            _thread_local.depth -= 1

    return wrap
