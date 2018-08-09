# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     HolidayApp.Repo.insert!(%HolidayApp.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias HolidayApp.Holidays.Holiday
alias HolidayApp.Repo

Repo.insert! %Holiday{date: ~D[2017-01-02], kind: "holiday", title: "New Year (moved)"}
Repo.insert! %Holiday{date: ~D[2017-01-09], kind: "holiday", title: "Orthodox Christmas (moved)"}
Repo.insert! %Holiday{date: ~D[2017-03-08], kind: "holiday", title: "International Women's Day"}
Repo.insert! %Holiday{date: ~D[2017-04-17], kind: "holiday", title: "Orthodox Easter (moved)"}
Repo.insert! %Holiday{date: ~D[2017-05-01], kind: "holiday", title: "Labour's Day 1"}
Repo.insert! %Holiday{date: ~D[2017-05-02], kind: "holiday", title: "Labour's Day 2"}
Repo.insert! %Holiday{date: ~D[2017-05-08], kind: "holiday", title: "Victory Day 0"}
Repo.insert! %Holiday{date: ~D[2017-05-09], kind: "holiday", title: "Victory Day 1"}
Repo.insert! %Holiday{date: ~D[2017-05-13], kind: "workday", title: "Workday for Victory Day"}
Repo.insert! %Holiday{date: ~D[2017-06-05], kind: "holiday", title: "Pentecost (moved)"}
Repo.insert! %Holiday{date: ~D[2017-06-28], kind: "holiday", title: "Day of Constitution"}
Repo.insert! %Holiday{date: ~D[2017-08-19], kind: "workday", title: "Workday for Independence Day"}
Repo.insert! %Holiday{date: ~D[2017-08-24], kind: "holiday", title: "Independence Day 1"}
Repo.insert! %Holiday{date: ~D[2017-08-25], kind: "holiday", title: "Independence Day 2"}
Repo.insert! %Holiday{date: ~D[2017-10-16], kind: "holiday", title: "Defender of Ukraine Day (moved)"}
Repo.insert! %Holiday{date: ~D[2017-12-25], kind: "holiday", title: "Catholic Christmas"}

Repo.insert! %Holiday{date: ~D[2018-01-01], kind: "holiday", title: "New Year"}
Repo.insert! %Holiday{date: ~D[2018-01-08], kind: "holiday", title: "Orthodox Christmas (moved)"}
Repo.insert! %Holiday{date: ~D[2018-03-03], kind: "workday", title: "Workday for International Women's Day"}
Repo.insert! %Holiday{date: ~D[2018-03-08], kind: "holiday", title: "International Women's Day 1"}
Repo.insert! %Holiday{date: ~D[2018-03-09], kind: "holiday", title: "International Women's Day 2"}
Repo.insert! %Holiday{date: ~D[2018-04-09], kind: "holiday", title: "Orthodox Easter (moved)"}
Repo.insert! %Holiday{date: ~D[2018-04-30], kind: "holiday", title: "Labour's Day 1"}
Repo.insert! %Holiday{date: ~D[2018-05-01], kind: "holiday", title: "Labour's Day 2"}
Repo.insert! %Holiday{date: ~D[2018-05-05], kind: "workday", title: "Workday for Labour's Day"}
Repo.insert! %Holiday{date: ~D[2018-05-09], kind: "holiday", title: "Victory Day"}
Repo.insert! %Holiday{date: ~D[2018-05-28], kind: "holiday", title: "Pentecost (moved)"}
Repo.insert! %Holiday{date: ~D[2018-06-23], kind: "workday", title: "Workday for Day of Constitution"}
Repo.insert! %Holiday{date: ~D[2018-06-28], kind: "holiday", title: "Day of Constitution 1"}
Repo.insert! %Holiday{date: ~D[2018-06-29], kind: "holiday", title: "Day of Constitution 2"}
Repo.insert! %Holiday{date: ~D[2018-08-24], kind: "holiday", title: "Independence Day"}
Repo.insert! %Holiday{date: ~D[2018-10-15], kind: "holiday", title: "Defender of Ukraine Day (moved)"}
Repo.insert! %Holiday{date: ~D[2018-12-22], kind: "workday", title: "Workday for Catholic Christmas"}
Repo.insert! %Holiday{date: ~D[2018-12-24], kind: "holiday", title: "Catholic Christmas 0"}
Repo.insert! %Holiday{date: ~D[2018-12-25], kind: "holiday", title: "Catholic Christmas 1"}
Repo.insert! %Holiday{date: ~D[2018-12-29], kind: "workday", title: "Workday for New Year's Eve"}
Repo.insert! %Holiday{date: ~D[2018-12-31], kind: "holiday", title: "New Year's Eve"}
