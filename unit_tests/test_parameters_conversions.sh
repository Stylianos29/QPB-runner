#!/bin/bash


# TODO: Write description
######################################################################
# unit_tests/test_parameters.sh - Script for 
#
#
######################################################################


# SOURCE DEPENDENCIES

LIBRARY_SCRIPTS_DIRECTORY_FULL_PATH="$(realpath ../library)"
# Source all custom functions scripts from "QPB-runner/library" using a
# loop avoiding this way name-specific sourcing and thus potential typos
for library_script in "$LIBRARY_SCRIPTS_DIRECTORY_FULL_PATH"/*;
do
    # Check if the current file in the loop is a regular file
    if [ -f "$library_script" ]; then
        source "$library_script"
    fi
done
unset LIBRARY_SCRIPTS_DIRECTORY_FULL_PATH

# COMMAND-LINE ARGUMENTS CHECKS

unittest_option_default_value="-v"
# Check if an argument is provided; if not, use the default value
unittest_option=${1:-$unittest_option_default_value}

# CUSTOM FUNCTIONS UNIT TESTS

test_extract_overlap_operator_method() {
    test_input_values_list=(
            # Relative paths with characteristic substring in different cases
            "/overlap-Chebyshev/scan.sh" \
            "/overlap-chebyshev/scan.sh" \
            "/overlap-CHEBYSHEV/scan.sh" \
            "/overlap-Zolotarev/scan.sh" \
            "/overlap-zolotarev/scan.sh" \
            "/overlap-ZOLOTAREV/scan.sh" \
            "/overlap-Neuberger/scan.sh" \
            "/overlap-neuberger/scan.sh" \
            "/overlap-NEUBERGER/scan.sh" \
            "/overlap-KL/scan.sh" \
            "/overlap-kl/scan.sh" \
            "/mainprogs/scan.sh" \
            # Full paths that might mislead the extraction
            "/KL_multishift_scaling/qpb/mainprogs/invert/qpb_parameters_scan_files/scan.sh" \
            "/KL_multishift_scaling/qpb/mainprogs/overlap-kl/invert/qpb_parameters_scan_files/scan.sh" \
            "/Chebyshev_modified_eigenvalues/qpb/mainprogs/overlap-Chebyshev/invert/qpb_parameters_scan_files/scan.sh" \
            "/Zolotarev_tests/qpb/mainprogs/overlap-Zolotarev/sign-squared-violation/qpb_parameters_scan_files/scan.sh" \
            "/Neuberger_scaling/qpb/mainprogs/overlap-Neuberger/invert/qpb_parameters_scan_files/scan.sh" \
            "/Chebyshev_modified_eigenvalues/qpb/mainprogs/invert/qpb_parameters_scan_files/scan.sh"
        )
    expected_output_values_list=(
            "Chebyshev" \
            "Chebyshev" \
            "Chebyshev" \
            "Zolotarev" \
            "Zolotarev" \
            "Zolotarev" \
            "Neuberger" \
            "Neuberger" \
            "Neuberger" \
            "KL" \
            "KL" \
            "Bare" \
            "Bare" \
            "KL" \
            "Chebyshev" \
            "Zolotarev" \
            "Neuberger" \
            "Bare"
        )

    assert_multiple_function_outputs extract_overlap_operator_method \
                            test_input_values_list expected_output_values_list
}


test_extract_kernel_operator_type() {
    # Positive tests
    test_input_values_list=("Standard" "Stan" "0" "Brillouin" "Bri" "1")
    expected_output_values_list=("Standard" "Standard" "Standard" \
                                        "Brillouin" "Brillouin" "Brillouin")

    assert_multiple_function_outputs extract_kernel_operator_type \
                test_input_values_list expected_output_values_list || return 1

    # Negative test
    ! extract_kernel_operator_type "INCORRECT_INPUT" > /dev/null 2>&1 \
                                                                    || return 1
}


test_extract_QCD_beta_value() {
    # Positive tests
    test_input_values_list=(
        "/nvme/h/cy22sg1/scratch/Nf0/Nf0_b6p20_L24T48-APE" \
        "/nvme/h/cy22sg1/scratch/Nf0/Nf0_b5p20_L16T32-APE" \
        )
    expected_output_values_list=("6.20" "5.20")

    assert_multiple_function_outputs extract_QCD_beta_value \
                test_input_values_list expected_output_values_list || return 1

    # Negative test
    ! extract_QCD_beta_value "INCORRECT_INPUT" > /dev/null 2>&1 || return 1
}


test_extract_lattice_dimensions() {
    # Positive tests
    test_input_values_list=(
        "/nvme/h/cy22sg1/scratch/Nf0/Nf0_b6p20_L24T48-APE" \
        "/nvme/h/cy22sg1/scratch/Nf0/Nf0_b5p20_L16T32-APE"
        )
    expected_output_values_list=("48 24 24 24" "32 16 16 16")

    assert_multiple_function_outputs extract_lattice_dimensions \
                test_input_values_list expected_output_values_list || return 1

    # Negative test
    ! extract_lattice_dimensions "INCORRECT_INPUT" > /dev/null 2>&1 || return 1
}


test_extract_configuration_label_from_file() {
    # Positive tests
    test_input_values_list=(
        "conf_Nf0_b6p20_L24T48_apeN1a0p72.0024200" \
        "conf_Nf0_b6p20_L24T48.0036800" \
        )
    expected_output_values_list=("0024200" "0036800")

    assert_multiple_function_outputs extract_configuration_label_from_file \
                test_input_values_list expected_output_values_list || return 1

    # Negative test
    ! extract_configuration_label_from_file "INCORRECT_INPUT" >/dev/null 2>&1 \
                                                                    || return 1
}


test_calculate_kappa_value_from_bare_mass() {
    test_input_values_list=("1.0" "1" "-2" "-4.5")
    expected_output_values_list=("0.1" "0.1" "0.25" "-1.0")

    assert_multiple_function_outputs calculate_kappa_value_from_bare_mass \
                test_input_values_list expected_output_values_list
}


test_calculate_bare_mass_from_kappa_value() {
    test_input_values_list=("0.1" "0.1" "0.25" "-1.0")
    expected_output_values_list=("1.0" "1.0" "-2.0" "-4.5")

    assert_multiple_function_outputs calculate_bare_mass_from_kappa_value \
                test_input_values_list expected_output_values_list
}


test_calculate_number_of_tasks_from_mpi_geometry() {
    test_input_values_list=("2,2,2" "3,2,1")
    expected_output_values_list=("8" "6")

    assert_multiple_function_outputs \
        calculate_number_of_tasks_from_mpi_geometry \
                test_input_values_list expected_output_values_list
}

# Missing tests for:
# - extract_configuration_label_from_file()
# - match_configuration_label_to_file()
# - extract_lattice_dimensions_label_with_value()


test_fnv1a_hash() {
    # NOTE: The expected values are those of a reference 32-bit FNV-1a
    # implementation. Pinning them guards the pure-Bash arithmetic, in
    # particular the 32-bit masking, against silent regressions.
    test_input_values_list=("" "a" "test" "0024200#0")
    expected_output_values_list=(\
            "2166136261" "3826002220" "2949673445" "3887519472")

    assert_multiple_function_outputs fnv1a_hash \
                            test_input_values_list expected_output_values_list
}


test_fmix32_finalizer() {
    # NOTE: The expected values are those of the reference MurmurHash3 32-bit
    # finalizer. They guard the 16-bit-halves multiplication, which is what
    # keeps the two mixing constants from overflowing Bash signed arithmetic.
    test_input_values_list=("0" "1" "3887519472")
    expected_output_values_list=("0" "1364076727" "168184442")

    assert_multiple_function_outputs fmix32_finalizer \
                            test_input_values_list expected_output_values_list
}


test_gauge_shifts_from_configuration_label() {
    # The function falls back on "LATTICE_DIMENSIONS" when no dimensions are
    # passed. NOTE: Bash dynamic scoping makes this local visible to it.
    local LATTICE_DIMENSIONS="48 24 24 24"

    # Positive tests
    test_input_values_list=("0024200" "0024400" "0024600" "0000200" "0060000")
    expected_output_values_list=(\
            "26 9 15 14" \
            "23 23 21 4" \
            "24 4 16 5" \
            "35 10 12 8" \
            "7 0 2 12" \
        )

    assert_multiple_function_outputs gauge_shifts_from_configuration_label \
            test_input_values_list expected_output_values_list || return 1

    # The dimensions may also be passed explicitly, overriding the global
    local shifts=$(gauge_shifts_from_configuration_label "0024200" \
                                                            "32 16 16 16")
    [ "$shifts" == "26 1 15 6" ] || return 1

    # Every component must stay within the bounds of its own dimension
    is_valid_gauge_shifts "$shifts" "32 16 16 16" || return 1

    # The mapping must be reproducible
    [ "$(gauge_shifts_from_configuration_label "0024200")" \
        == "$(gauge_shifts_from_configuration_label "0024200")" ] || return 1

    # Negative tests: empty label, and malformed lattice dimensions
    ! gauge_shifts_from_configuration_label "" > /dev/null 2>&1 || return 1
    ! gauge_shifts_from_configuration_label "0024200" "48 24 24" \
                                                > /dev/null 2>&1 || return 1
    ! gauge_shifts_from_configuration_label "0024200" "48 24 24 abc" \
                                                > /dev/null 2>&1 || return 1
}


test_gauge_shifts_are_well_spread() {
:   '
    Regression test for the decorrelation of the derived gauge shifts.

    Configuration labels of an ensemble are sparse and regular, typically
    advancing in steps of 200. Counting how many distinct values each single
    direction takes is NOT enough to detect a poor mapping: a mapping whose
    four directions are strongly correlated with each other still covers every
    single-direction value. What this test therefore checks is the number of
    distinct shift 4-tuples and the number of distinct relative offsets between
    directions. Reducing an unavalanched FNV-1a hash modulo a lattice dimension
    yields only 53 distinct tuples and 6 distinct offsets here, against the 300
    and 24 of a well spread mapping.
    '

    local LATTICE_DIMENSIONS="48 24 24 24"
    local ensemble_size=300

    local index label shifts
    local shifts_array=()
    for (( index = 1; index <= ensemble_size; index++ )); do
        printf -v label "%07d" $(( 200 * index ))
        shifts_array+=("$(gauge_shifts_from_configuration_label "$label")")
    done

    # Count the distinct shift 4-tuples
    local distinct_tuples=$(printf '%s\n' "${shifts_array[@]}" | sort -u | wc -l)
    [ "$distinct_tuples" -ge 280 ] || {
        echo "ERROR: Only ${distinct_tuples} distinct gauge shifts tuples out"\
            "of ${ensemble_size} configurations."
        return 1
        }

    # Count the distinct offsets between the 2nd and the 3rd direction
    local distinct_offsets=$(printf '%s\n' "${shifts_array[@]}" \
        | awk '{ print ($3 - $2 + 24) % 24 }' | sort -u | wc -l)
    [ "$distinct_offsets" -ge 20 ] || {
        echo "ERROR: Only ${distinct_offsets} distinct offsets between the"\
            "2nd and the 3rd direction; the directions are correlated."
        return 1
        }
}


test_default_gauge_shifts() {
    test_input_values_list=(\
            "Bare_invert" "KL_invert" "Zolotarev_invert" \
            "Bare" "KL" "Chebyshev" "Zolotarev" "Neuberger" \
        )
    expected_output_values_list=(\
            "0 0 0 0" "0 0 0 0" "0 0 0 0" \
            "14 7 6 2" "14 7 6 2" "14 7 6 2" "14 7 6 2" "14 7 6 2" \
        )

    assert_multiple_function_outputs default_gauge_shifts \
                            test_input_values_list expected_output_values_list
}

unittest $unittest_option
