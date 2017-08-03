(* Copyright (C) 2017  Petter A. Urkedal <paurkedal@gmail.com>
 *
 * This library is free software; you can redistribute it and/or modify it
 * under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or (at your
 * option) any later version, with the OCaml static compilation exception.
 *
 * This library is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Lesser General Public
 * License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this library.  If not, see <http://www.gnu.org/licenses/>.
 *)

(** Signature of connection handles. *)

module type S = sig
  type 'a io

  module Response : Caqti_response_sig.S with type 'a io := 'a io

  val call :
    f: (('b, 'm) Response.t -> ('c, 'e) result io) ->
    ('a, 'b, 'm) Caqti_request.t -> 'a ->
    ('c, [> Caqti_error.t] as 'e) result io
  (** [call ~f request params] performs [request] with parameters [params]
      invoking [f] to process the result. *)

  val exec :
    ('a, unit, [< `Zero]) Caqti_request.t -> 'a ->
    (unit, [> Caqti_error.t] as 'e) result io

  val find :
    ('a, 'b, [< `One]) Caqti_request.t -> 'a ->
    ('b, [> Caqti_error.t] as 'e) result io

  val find_opt :
    ('a, 'b, [< `Zero | `One]) Caqti_request.t -> 'a ->
    ('b option, [> Caqti_error.t] as 'e) result io

  val fold :
    ('a, 'b, [< `Zero | `One | `Many]) Caqti_request.t ->
    ('b -> 'c -> 'c) ->
    'a -> 'c -> ('c, [> Caqti_error.t] as 'e) result io

  val fold_s :
    ('a, 'b, [< `Zero | `One | `Many]) Caqti_request.t ->
    ('b -> 'c -> ('c, 'e) result io) ->
    'a -> 'c -> ('c, [> Caqti_error.t] as 'e) result io

  val iter_s :
    ('a, 'b, [< `Zero | `One | `Many]) Caqti_request.t ->
    ('b -> (unit, 'e) result io) ->
    'a -> (unit, [> Caqti_error.t] as 'e) result io

end
