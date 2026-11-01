# Regenerated Venue-Selection Agent
# Python 3.9+ script implementing the blended Master Ranking Criteria Matrix

"""
Source: original agent specification used as a base for priorities.
(See uploaded file with original Master Ranking Criteria Matrix.) [[2]]
"""

import math
from typing import Dict, Any, List, Tuple

# -----------------------------
# Configuration: hard flags & weights (0-100)
# -----------------------------
CONFIG = {
    # Hard constraints (True = enforce as hard filter)
    "hard_constraints": {
        "solicitation_mitigation": True,
        "network_infrastructure_minimum": True,
        "no_casino": True,               # enforce No Casino for profiles where applicable
        "no_smoking": True,              # enforce fully non-smoking property if required
        "max_rate_hard_cutoff": True,    # enforce max \$105 pre-tax as hard filter
        "onsite_event_center_required": False,  # set True if event strictly requires onsite event center
        "onsite_ems_required": False,    # set True if EMS is required as a hard gate
    },

    # Numeric thresholds for hard constraints (when enforced)
    "thresholds": {
        "network_infrastructure_mbps": 500,  # example threshold for total/event bandwidth
        "max_rate_pre_tax": 105.0,
        "max_drive_time_to_airport_mins": 60,  # used if you want to gate airport distance
    },

    # Scoring weights for soft-criteria (0-100)
    "weights": {
        "network_infrastructure": 95,
        "safety": 90,
        "onsite_ems": 88,
        "room_block_financials": 85,
        "affordability": 82,
        "logistics_event_windows": 78,
        "onsite_event_center": 76,
        "wellness_amenities": 70,
        "external_gym_proximity": 60,
        "ev_charging": 66,
        "dining_walkability": 62,
        "sentiment_service": 60,
        "brand_prestige": 55,
        "hotel_shuttle": 50,
        "airport_distance": 45,
        "breakfast_included": 44,
        "pet_policy": 40,
        "further_from_downtown": 35,
        "yacht_access": 30,
        "in_n_out_distance": 10,
        "nightlife_proximity": 10,
        "misc_tiebreaker": 5,
    },

    # Normalization caps (for converting raw values to 0-1)
    "norm_caps": {
        "max_bandwidth_mbps": 10000,
        "max_room_rate": 500,
        "max_distance_miles": 50,
        "max_drive_time_mins": 120,
        "max_restaurants_within_walk": 20,
        "max_ev_chargers": 20,
    },

    # Walkability distance in minutes
    "walk_minutes_threshold": 15,
}

# -----------------------------
# Data model for a property (example)
# -----------------------------
# Each candidate property should include the following fields (names used below).
# Some fields are boolean, others numeric. Use None for unknown values.

# Example property schema (dictionary):
# {
#   "id": "prop_001",
#   "name": "Example Hotel",
#   "address": "...",
#   "has_casino": False,
#   "smoking_policy": "non-smoking" / "designated-outdoor" / "smoking-allowed",
#   "rate_pre_tax": 95.0,
#   "bandwidth_mbps": 1000,
#   "safety_score": 0.85,   # 0-1 (derived from crime stats & property security)
#   "onsite_ems": False,
#   "onsite_ems_response_mins": 12,
#   "room_block_discount_pct": 15.0,
#   "onsite_event_center": True,
#   "event_center_capacity": 1500,
#   "event_center_sqft": 8000,
#   "event_center_av_required": True,
#   "conference_availability_dates": ["2026-09-13","2026-09-17"], # example
#   "fitness_on_site": True,
#   "spa_on_site": True,
#   "distance_to_external_gym_miles": 1.2,
#   "ev_chargers_count": 6,
#   "ev_charger_types": ["Level2","DC Fast"],
#   "restaurants_within_walk_count": 12,
#   "restaurants_within_walk_score": 0.78, # normalized 0-1 (excluding excluded chains)
#   "sentiment_service_score": 0.9, # 0-1
#   "brand_prestige_score": 0.7, # 0-1
#   "hotel_shuttle": True,
#   "shuttle_schedule": {"airport": "on-demand"},
#   "distance_to_airport_mins": 28,
#   "distance_to_downtown_miles": 7.4,
#   "yacht_access": False,
#   "in_n_out_distance_miles": 3.2,
#   "nightlife_is_close": False,
#   "breakfast_included": True,
#   "pet_policy": {"allowed": True, "fee": 50, "restrictions": "dogs only, <50lbs"},
#   "data_completeness": { ... }  # optional: track which fields are populated vs missing
# }

# -----------------------------
# Utility normalizers
# -----------------------------
def normalize_linear(value: float, cap: float) -> float:
    if value is None:
        return 0.0
    if value <= 0:
        return 0.0
    return min(1.0, float(value) / cap)


def invert_normalize_distance(miles: float, cap: float) -> float:
    # Closer is better: returns 1.0 for 0 miles, 0.0 at cap or greater
    if miles is None:
        return 0.0
    if miles <= 0:
        return 1.0
    return max(0.0, 1.0 - min(miles, cap) / cap)


# -----------------------------
# Hard-constraint checks
# -----------------------------
def check_hard_constraints(prop: Dict[str, Any], cfg: Dict[str, Any]) -> Tuple[bool, List[str]]:
    """
    Returns (passes_all, list_of_fail_reasons)
    """
    fails = []
    hc = cfg["hard_constraints"]
    th = cfg["thresholds"]

    # Solicitation Mitigation: this is domain-specific. For demo, check: no_casino & smoking_policy
    if hc.get("solicitation_mitigation", False):
        # example heuristics; real checks should be more elaborate
        if prop.get("has_casino", False):
            fails.append("fails solicitation_mitigation: has casino")
        if prop.get("smoking_policy", "") == "smoking-allowed":
            fails.append("fails solicitation_mitigation: smoking allowed in rooms")

    # Network infra minimum
    if hc.get("network_infrastructure_minimum", False):
        bw = prop.get("bandwidth_mbps")
        if bw is None or bw < th["network_infrastructure_mbps"]:
            fails.append(f"insufficient_network_bandwidth: {bw}")

    # No Casino
    if hc.get("no_casino", False) and prop.get("has_casino", False):
        fails.append("has_on_site_casino")

    # No Smoking
    if hc.get("no_smoking", False):
        policy = prop.get("smoking_policy")
        if policy is None or policy != "non-smoking":
            fails.append(f"smoking_policy_not_strict_non-smoking: {policy}")

    # Max rate hard cutoff
    if hc.get("max_rate_hard_cutoff", False):
        rate = prop.get("rate_pre_tax")
        if rate is None:
            fails.append("rate_unknown_for_hard_cutoff")
        elif rate > th["max_rate_pre_tax"]:
            fails.append(f"rate_exceeds_cap: {rate}")

    # Onsite event center required
    if hc.get("onsite_event_center_required", False) and not prop.get("onsite_event_center", False):
        fails.append("onsite_event_center_required_but_missing")

    # Onsite EMS required
    if hc.get("onsite_ems_required", False) and not prop.get("onsite_ems", False):
        fails.append("onsite_ems_required_but_missing")

    return (len(fails) == 0, fails)


# -----------------------------
# Scoring functions per criterion
# -----------------------------
def score_network_infrastructure(prop: Dict[str, Any], cfg: Dict[str, Any]) -> float:
    return normalize_linear(prop.get("bandwidth_mbps") or 0.0, cfg["norm_caps"]["max_bandwidth_mbps"])


def score_safety(prop: Dict[str, Any], cfg: Dict[str, Any]) -> float:
    # expects prop["safety_score"] as 0..1 existing metric; otherwise fallback to 0
    return prop.get("safety_score", 0.0)


def score_onsite_ems(prop: Dict[str, Any], cfg: Dict[str, Any]) -> float:
    # Prefer onsite EMS (1.0) or short response time
    if prop.get("onsite_ems", False):
        return 1.0
    resp = prop.get("onsite_ems_response_mins")
    if resp is None:
        return 0.0
    # normalize inverse (closer -> higher)
    return invert_normalize_distance(resp, cfg["norm_caps"]["max_drive_time_mins"])


def score_room_block_financials(prop: Dict[str, Any], cfg: Dict[str, Any]) -> float:
    # Use room_block_discount_pct and attrition friendliness (not modeled here)
    disc = prop.get("room_block_discount_pct", 0.0)
    # normalize against a reasonable cap (e.g., 50% discount)
    return min(1.0, disc / 50.0)


def score_affordability(prop: Dict[str, Any], cfg: Dict[str, Any]) -> float:
    # Lower price is better. Normalize inverse of rate against cap.
    rate = prop.get("rate_pre_tax")
    if rate is None:
        return 0.0
    # If the budget cap is enforced as hard constraint, a property that passed is <= cap.
    cap = cfg["norm_caps"]["max_room_rate"]
    return invert_normalize_distance(rate, cap)  # reuse invert with rate interpreted vs cap


def score_logistics_event_windows(prop: Dict[str, Any], cfg: Dict[str, Any]) -> float:
    # Simplified: 1.0 if available in requested window (expected to be precomputed), else 0
    avail_dates = prop.get("conference_availability_dates", [])
    # In real agent, check overlap with requested event window
    return 1.0 if avail_dates else 0.0


def score_onsite_event_center(prop: Dict[str, Any], cfg: Dict[str, Any]) -> float:
    if prop.get("onsite_event_center"):
        # factor capacity into score (larger capacity => higher)
        cap = prop.get("event_center_capacity", 0)
        # normalize by an arbitrary useful cap (e.g., 5000 attendees)
        return normalize_linear(cap, 5000)
    return 0.0


def score_wellness_and_gyms(prop: Dict[str, Any], cfg: Dict[str, Any]) -> float:
    on_site = 1.0 if (prop.get("fitness_on_site") or prop.get("spa_on_site")) else 0.0
    # external gym proximity: closer is better
    ext = invert_normalize_distance(prop.get("distance_to_external_gym_miles"), cfg["norm_caps"]["max_distance_miles"])
    # blend: onsite preferred + external supplement
    return 0.6 * on_site + 0.4 * ext


def score_ev_charging(prop: Dict[str, Any], cfg: Dict[str, Any]) -> float:
    return normalize_linear(prop.get("ev_chargers_count") or 0, cfg["norm_caps"]["max_ev_chargers"])


def score_dining_walkability(prop: Dict[str, Any], cfg: Dict[str, Any]) -> float:
    # rely on restaurants_within_walk_score (0-1) which should exclude undesired chains
    return prop.get("restaurants_within_walk_score", 0.0)


def score_sentiment(prop: Dict[str, Any], cfg: Dict[str, Any]) -> float:
    return prop.get("sentiment_service_score", 0.0)


def score_brand_prestige(prop: Dict[str, Any], cfg: Dict[str, Any]) -> float:
    return prop.get("brand_prestige_score", 0.0)


def score_hotel_shuttle(prop: Dict[str, Any], cfg: Dict[str, Any]) -> float:
    return 1.0 if prop.get("hotel_shuttle", False) else 0.0


def score_airport_distance(prop: Dict[str, Any], cfg: Dict[str, Any]) -> float:
    # closer to airport is better; cap uses max_drive_time_mins
    return invert_normalize_distance(prop.get("distance_to_airport_mins"), cfg["norm_caps"]["max_drive_time_mins"])


def score_breakfast_included(prop: Dict[str, Any], cfg: Dict[str, Any]) -> float:
    return 1.0 if prop.get("breakfast_included", False) else 0.0


def score_pet_policy(prop: Dict[str, Any], cfg: Dict[str, Any]) -> float:
    pet = prop.get("pet_policy")
    if not pet:
        return 0.0
    # simplistic: allowed => 1.0, otherwise 0
    return 1.0 if pet.get("allowed", False) else 0.0


def score_further_from_downtown(prop: Dict[str, Any], cfg: Dict[str, Any]) -> float:
    # If you prefer properties further from downtown, normalize distance_to_downtown positively
    miles = prop.get("distance_to_downtown_miles")
    return normalize_linear(miles or 0.0, cfg["norm_caps"]["max_distance_miles"])


def score_yacht_access(prop: Dict[str, Any], cfg: Dict[str, Any]) -> float:
    return 1.0 if prop.get("yacht_access", False) else 0.0


def score_in_n_out_distance(prop: Dict[str, Any], cfg: Dict[str, Any]) -> float:
    # This is niche; closer returns higher value
    return invert_normalize_distance(prop.get("in_n_out_distance_miles"), cfg["norm_caps"]["max_distance_miles"])


def score_nightlife_proximity(prop: Dict[str, Any], cfg: Dict[str, Any]) -> float:
    # low priority; prefer low nightlife proximity if agent prefers isolation
    return 0.0 if prop.get("nightlife_is_close", False) else 1.0


# -----------------------------
# Composite scoring & ranking
# -----------------------------
CRITERIA_TO_FUNC = {
    "network_infrastructure": score_network_infrastructure,
    "safety": score_safety,
    "onsite_ems": score_onsite_ems,
    "room_block_financials": score_room_block_financials,
    "affordability": score_affordability,
    "logistics_event_windows": score_logistics_event_windows,
    "onsite_event_center": score_onsite_event_center,
    "wellness_amenities": score_wellness_and_gyms,
    "external_gym_proximity": lambda p, c: invert_normalize_distance(p.get("distance_to_external_gym_miles"), c["norm_caps"]["max_distance_miles"]),
    "ev_charging": score_ev_charging,
    "dining_walkability": score_dining_walkability,
    "sentiment_service": score_sentiment,
    "brand_prestige": score_brand_prestige,
    "hotel_shuttle": score_hotel_shuttle,
    "airport_distance": score_airport_distance,
    "breakfast_included": score_breakfast_included,
    "pet_policy": score_pet_policy,
    "further_from_downtown": score_further_from_downtown,
    "yacht_access": score_yacht_access,
    "in_n_out_distance": score_in_n_out_distance,
    "nightlife_proximity": score_nightlife_proximity,
}


def compute_composite_score(prop: Dict[str, Any], cfg: Dict[str, Any]) -> Tuple[float, Dict[str, float]]:
    """
    Returns (composite_score, breakdown_dict) where composite_score is a weighted sum normalized by total weights applied.
    """
    weights = cfg["weights"]
    total_weight = 0.0
    score_sum = 0.0
    breakdown = {}

    for crit, func in CRITERIA_TO_FUNC.items():
        w = weights.get(crit, 0)
        if w <= 0:
            continue
        s = func(prop, cfg)
        breakdown[crit] = s
        score_sum += s * w
        total_weight += w

    composite = (score_sum / total_weight) if total_weight > 0 else 0.0
    return composite, breakdown


# -----------------------------
# Ranking pipeline
# -----------------------------
def rank_properties(props: List[Dict[str, Any]], cfg: Dict[str, Any]) -> List[Dict[str, Any]]:
    """
    Filters by hard constraints, scores remaining properties, and returns a sorted list by composite score desc.
    Each result includes pass/fail details and breakdown.
    """
    results = []
    for p in props:
        passes, fails = check_hard_constraints(p, cfg)
        if not passes:
            # include failures in output for transparency
            results.append({
                "id": p.get("id"),
                "name": p.get("name"),
                "passed": False,
                "fail_reasons": fails,
                "composite_score": None,
                "breakdown": None,
            })
            continue

        composite, breakdown = compute_composite_score(p, cfg)
        results.append({
            "id": p.get("id"),
            "name": p.get("name"),
            "passed": True,
            "fail_reasons": [],
            "composite_score": composite,
            "breakdown": breakdown,
        })

    # Sort passing properties by composite score desc; failing ones can be listed at the end
    passing = [r for r in results if r["passed"]]
    failing = [r for r in results if not r["passed"]]

    passing_sorted = sorted(passing, key=lambda r: r["composite_score"], reverse=True)
    return passing_sorted + failing


# -----------------------------
# Example usage (demo)
# -----------------------------
if __name__ == "__main__":
    # Example properties (minimal demo)
    sample_props = [
        {
            "id": "prop_01",
            "name": "Off-Strip Corporate Retreat",
            "has_casino": False,
            "smoking_policy": "non-smoking",
            "rate_pre_tax": 102.0,
            "bandwidth_mbps": 1500,
            "safety_score": 0.9,
            "onsite_ems": True,
            "onsite_ems_response_mins": 8,
            "room_block_discount_pct": 20.0,
            "onsite_event_center": True,
            "event_center_capacity": 1200,
            "fitness_on_site": True,
            "spa_on_site": True,
            "distance_to_external_gym_miles": 0.5,
            "ev_chargers_count": 4,
            "restaurants_within_walk_score": 0.8,
            "sentiment_service_score": 0.95,
            "brand_prestige_score": 0.7,
            "hotel_shuttle": True,
            "distance_to_airport_mins": 32,
            "breakfast_included": True,
            "pet_policy": {"allowed": True, "fee": 75},
            "distance_to_downtown_miles": 9.0,
            "yacht_access": False,
            "in_n_out_distance_miles": 2.5,
            "nightlife_is_close": False,
        },
        {
            "id": "prop_02",
            "name": "Budget Chain Near Strip",
            "has_casino": False,
            "smoking_policy": "designated-outdoor",
            "rate_pre_tax": 88.0,
            "bandwidth_mbps": 200,
            "safety_score": 0.6,
            "onsite_ems": False,
            "onsite_ems_response_mins": 20,
            "room_block_discount_pct": 10.0,
            "onsite_event_center": False,
            "event_center_capacity": 0,
            "fitness_on_site": False,
            "spa_on_site": False,
            "distance_to_external_gym_miles": 0.2,
            "ev_chargers_count": 0,
            "restaurants_within_walk_score": 0.3,
            "sentiment_service_score": 0.5,
            "brand_prestige_score": 0.3,
            "hotel_shuttle": False,
            "distance_to_airport_mins": 35,
            "breakfast_included": False,
            "pet_policy": None,
            "distance_to_downtown_miles": 3.0,
            "yacht_access": False,
            "in_n_out_distance_miles": 0.8,
            "nightlife_is_close": True,
        },
    ]

    ranked = rank_properties(sample_props, CONFIG)
    for r in ranked:
        print("== Property:", r["name"])
        print("Passed hard constraints:", r["passed"])
        if r["passed"]:
            print("Composite score:", round(r["composite_score"], 4))
            print("Breakdown (sample):")
            # print top 6 criteria for readability
            for k, v in sorted(r["breakdown"].items(), key=lambda kv: CONFIG["weights"].get(kv[0], 0), reverse=True)[:8]:
                print(f"  {k}: {v:.3f} (weight {CONFIG['weights'].get(k, '?')})")
        else:
            print("Fail reasons:", r["fail_reasons"])
        print("")