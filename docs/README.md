# Notes

## Types of rules

Rules are used to determine whether a given user must be assigned, or not, to a bucket.

* `SIMPLE`: Either `true` or `false` for everybody
* `ATTRIBUTES`: Determined based on user attribute, _e.g. location_
* `GODSEND`: Determined based on a threshold, _e.g. 20%_
* `ATTRIBUTES_GODSEND`: Users that comply to attributes-based rules may be assigned, or not, to a bucket, based on a threshold, _e.g. 20% of users in Melbourne_

## Create user

A user is represented by a payload, _e.g. `{ id: 123, location: "Melbourne" }`_

* START
  * id present?
    * YES
      * user exist?
        * YES
          * update user
          * END
        * NO
          * calculate hash
          * create new user
          * END
    * NO
      * calculate hash
      * hash exists?
        * YES
          * update user
          * END
        * NO
          * calculate hash
          * create new user
          * END

## Create user's hash
Anonymous users are represented by an hash calculated on user's attributes. Such hash can be used to identify an user that registers to the website and it's no longer a guest, so that all the toggles still apply.
