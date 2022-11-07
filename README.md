# usvisa-rescheduler

US VISA (ais.usvisa-info.com) appointment re-scheduler - Brazil edition

# How to use

You will need Ruby 3.1 and Google Chrome installed.

1. Fill out your information at `main.rb`: `username`, `password` and `schedule_id`. The scheduled ID can be found in the URL.
2. You can also change your targeting date.
3. The default behavior is to BEEP when a date is available and you have to manually submit the form, but automatic schedule is implemented. This last feature is poorly tested, and can be improved.
4. Run the script with

```
ruby main.rb
```

5. Wait for the BEEPs

_PS: You will get blocked after trying too long to find a date (no dates will be available). Wait around 6h after trying again_

# TODO

- `main.rb` is a bit confusing and can be better parameterized.
- Error treatment should be better implemented, specially during automatic submit. This scenario is hard to test when very few dates are available.

---

Inspired by https://github.com/uxDaniel/visa_rescheduler
