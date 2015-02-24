web: bundle exec puma -t ${PUMA_MIN_THREADS:-10}:${PUMA_MAX_THREADS:-10} -w ${PUMA_WORKERS:-2} -p $PORT -e ${RACK_ENV:-development}
resque: env TERM_CHILD=1 RESQUE_TERM_TIMEOUT=7 QUEUES=* bundle exec rake resque:work
scheduler: bundle exec rake resque:scheduler