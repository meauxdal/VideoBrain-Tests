# Information Manager hardware test plan

Purpose: check the operating rules reconstructed from the September 1978 VB-1200 ROM on physical MiSTer hardware. Expected results below are ROM-derived predictions unless noted otherwise. Record what actually happens, including results that contradict the prediction.

Use [RESULTS.md](RESULTS.md) as the run log. The [user manual](https://github.com/meauxdal/VideoBrain_MiSTer/blob/main/docs/INFOMAN-MANUAL.md) explains ordinary operation; this document defines experiments, including incomplete or potentially surprising behavior.

## Start here

1. Record the core build/RBF filename, cartridge and Expander 1 firmware identities, keyboard used and test date.
2. Make fresh writable copies of the core's example blank tape for the fixture and output filenames below. Keep fixture images unchanged once verified.
3. NEXT is F3/Enter; SPECIAL is F4. Submit a command with NEXT. Use plain lengths such as 8, not padded entry.
4. Start with pass 1. Start pass 2 only after text entry, multi-record review and EDIT copy-through work. Pass 3 is the longer edge-case session.

If time is short, complete T01-T04, E01-E07 and M01. These establish the text database foundation and the least-certain editing/tape behaviors. Numeric work can follow independently.

## Rules for every run

- A **fresh REVIEW** means exit to the opening screen, mount/rewind the source in Playback, then enter R. It starts with the first record loaded.
- A **fresh EDIT** means mount/rewind the unchanged source in Playback, mount a separate fresh blank in Record, then enter ED. It starts with the first source record loaded. Do not list with P ALL before a mutation unless the test explicitly asks for that.
- Never use the source filename for an output. Give each test its own output image. Rewind Record only before a new EDIT; preserve its position during MERGE.
- At editable field displays, accept unchanged values with NEXT unless the case asks for a change. Capture unexpected prompts before responding; log every extra key used.
- Finish normal EDIT runs with EXIT. Wait for recording activity and the user LED to clear before changing images or resetting.
- **Every output test requires reload:** mount its output as Playback, rewind, enter R and use PRINT ALL. Compare every field, record order and record count. Tape idle or a return to the menu is not a pass by itself.
- If a prerequisite fails, preserve its VBT and stop dependent cases. Mark them BLOCKED; continue independent tests using a known-good fixture.
- Preserve unexpected output even if it is unreadable. Record cartridge messages separately from MiSTer controller notices. If a hang requires reset, label that output interrupted rather than treating it as a completed save.

## Fixtures

Create these through ENTER on hardware so the fixtures test the cartridge's own writer. Do not start with synthesized tape payloads.

### TEXT-A: im-text-a.vbt

Database name TEXTA. Fields, in order: ITEM, length 8, type A; ZONE, length 8, type A.

| Record | ITEM | ZONE |
|---|---|---|
| 1 | APPLE | WEST |
| 2 | PEAR | EAST |
| 3 | PLUM | WEST |
| 4 | APPLEPIE | NORTH |

After the second field definition, SPECIAL at empty NAME finishes the definition. Confirm Y, enter all four records, then SPECIAL at the next empty ITEM prompt finishes entry. Wait for recording to finish. The fourth name deliberately fills all eight characters and shares the APPLE prefix.

### TEXT-B: im-text-b.vbt

Database name TEXTB. Use exactly the same two field definitions and order as TEXT-A.

| Record | ITEM | ZONE |
|---|---|---|
| 1 | MELON | SOUTH |
| 2 | PEACH | EAST |

### NUM: im-num.vbt

Database name NUM. Fields in order: ITEM/A/8, ZONE/A/8, QTY/I/6, PRICE/M/8. In each triplet these mean name/type/length; the cartridge asks name, length, then type.

| Record | ITEM | ZONE | QTY | PRICE |
|---|---|---|---:|---:|
| 1 | APPLE | WEST | 2 | 1.25 |
| 2 | PEAR | EAST | 3 | 2.50 |
| 3 | PLUM | WEST | 4 | 0.75 |
| 4 | APPLEPIE | NORTH | 1 | 4.00 |

If numeric input cannot be completed, capture the first failing field and stop NUM-dependent tests. Keep TEXT-A/B for the text cases.

## Pass 1: text, navigation and edited outputs

### T01 - Create and reload TEXT-A

- [ ] Create TEXT-A with the two fields and four records above.
- [ ] Fresh REVIEW; submit PRINT ALL, then EXIT.
- Expected: all four records, both fields in definition order, exact values, then END OF TAPE. This establishes multiple fields/records and length 8 entered without leading zeroes.
- Evidence: fixture image, full listing capture, recording completion and any messages.
- If this fails, use a fresh one-field ITEM/A/8 APPLE database to distinguish a basic save/load regression from a multi-field failure. Stop tests requiring TEXT-A until resolved.

### T02 - DESC and aliases without consuming a record

- [ ] Fresh REVIEW of TEXT-A; submit DESC, P DESC, then P ALL; exit with E.
- Expected: both description commands show TEXTA and both NAME/LENGTH/TYPE definitions; the subsequent listing still begins with APPLE.
- Confirm R/REVIEW, P/PRINT and E/EXIT spellings used. The known main-menu REVIE prefix can be rechecked here; it is not evidence about slash-prompt prefixes.

### T03 - Current record and numeric PRINT arguments

Use a fresh REVIEW for each row. No Record tape is required.

| Commands | Predicted records displayed |
|---|---|
| P 0; P; P 0 | APPLE; PEAR; PEAR. Record whether each command returns to slash and advances. |
| P 2 | PEAR, PLUM. The number is a count starting after the loaded record. |
| P ALL | APPLE, PEAR, PLUM, APPLEPIE. |

- [ ] Photograph the record after each command, not just the final screen.
- These are important off-by-one checks. If the first row differs, do not assume later mutation-position predictions are correct.

### T04 - FLD persistence and DESC interaction

- [ ] Fresh REVIEW: FLD=ZONE; DESC; P 0; FLD=ITEM; P 0; P ALL.
- Expected: DESC still shows both definitions; first P 0 displays only ZONE: WEST; second displays only ITEM: APPLE. P ALL displays ITEM only for all four records, starting with APPLE.
- [ ] Exit, rewind and re-enter REVIEW; P 0 should show both fields again.

### T05 - Selection and matching probes

Use a fresh REVIEW for each row. Capture command spelling and all matches.

| Commands | Prediction / question |
|---|---|
| P ITEM=APPLE; P ITEM=APPLE | First finds APPLE, second finds APPLEPIE. Checks prefix comparison and post-match advancement. |
| P ITEM=P*AR | Finds PEAR. Checks the single-character wildcard. |
| P ITEM=P*R | Should not match PEAR if * consumes exactly one character. Record termination and any other match. |
| P ITEM=MISSING | No match; record END OF TAPE behavior and return to slash. |

- [ ] Do not invent quoting or multiple-match syntax during the main pass. Those grammar forms still need a complete trace before prescribing tests. Keep any exploratory spellings in the notes, separate from these cases.

### E01 - EDIT copy-through baseline

- [ ] Fresh EDIT of TEXT-A to im-copy.vbt; submit EXIT without other commands.
- Expected after reload: exactly TEXT-A, with all four records. This establishes the two-deck path before mutations.

### E02 - REPLACE current record

- [ ] Fresh EDIT to im-replace.vbt; submit R. Capture whether fields start blank.
- [ ] Enter APRICOT and WEST at the two field prompts, then EXIT.
- Expected after reload: APRICOT/WEST, PEAR/EAST, PLUM/WEST, APPLEPIE/NORTH. No new or missing record.

### E03 - ADD with no completed addition

- [ ] Fresh EDIT to im-add-zero.vbt; submit A; at the first empty ITEM prompt, press SPECIAL; then EXIT.
- Intended result: unchanged TEXT-A. **Open question:** the handler has already copied APPLE and reuses its buffer. Inspect specifically for an extra blank record, missing APPLE, duplication or altered ZONE.
- This is an experiment, not an established safe no-op. Preserve the resulting VBT regardless of outcome.

### E04 - ADD one record, then finish

- [ ] Fresh EDIT to im-add-one.vbt; submit ADD; enter ORANGE/NORTH; SPECIAL at the next empty ITEM prompt; EXIT.
- Intended order: APPLE, ORANGE, PEAR, PLUM, APPLEPIE. Verify every ZONE and look for a trailing/pending blank record after ORANGE.
- Depends on understanding E03's termination behavior; record an anomaly rather than working around it silently.

### E05 - DELETE current record and inspect prompts

- [ ] Fresh EDIT to im-del-current.vbt; submit D. Photograph any field prompts, accepting displayed values with NEXT if requested. Log any empty prompts or unexpected input requirements.
- [ ] At slash, EXIT; reload.
- Expected records: PEAR, PLUM, APPLEPIE with original ZONE values. The prompt sequence itself is a required result because the handler calls the field-display/input routine.

### E06 - DELETE a count

- [ ] Fresh EDIT to im-del-two.vbt; submit DELETE 2; capture/accept any field prompts as in E05; EXIT; reload.
- Expected: PLUM/WEST and APPLEPIE/NORTH. Confirms count relative to current record rather than absolute record numbering.

### E07 - DELETE remainder

- [ ] Fresh EDIT to im-del-all.vbt; submit D ALL; EXIT; reload.
- Expected: a readable definition and no data records. Capture whether REVIEW reaches slash and how P ALL reports the empty database.
- [ ] Optional separate run to im-del-tail.vbt: fresh EDIT, P (accept PEAR's displayed fields unchanged), D ALL, EXIT. Expected output: APPLE/WEST only, since P already copied the first record.

### E08 - DELETE by field match

- [ ] Fresh EDIT to im-del-match.vbt; submit D ITEM=PLUM; capture field interactions; EXIT; reload.
- Expected: APPLE/WEST, PEAR/EAST, APPLEPIE/NORTH. Confirms nonmatches are copied and only the matched record is omitted.

### M01 - MERGE two inputs

- [ ] Create TEXT-B and verify it independently with REVIEW / P ALL.
- [ ] Fresh EDIT of TEXT-A to im-merge.vbt; submit M.
- [ ] At REWIND / KEY NEXT, photograph the prompt and check whether both mount controls are available after tape activity stops.
- [ ] Mount TEXT-B in Playback at the beginning. Keep Record mounted and do not rewind it. Press NEXT.
- [ ] At slash, DESC; record whether it shows TEXTB. Then EXIT and wait for recording completion.
- Expected after reload: output definition TEXTA and six records in order APPLE, PEAR, PLUM, APPLEPIE, MELON, PEACH, with all ZONE values intact.
- This checks source drain, tape handoff, first-record retention, continued output position and original-header preservation. If mounting remains unavailable, capture both controller state and cartridge prompt; do not reset and then call the merge a pass.

## Pass 2: numeric fields and reports

### N01 - Create and reload NUM

- [ ] Create NUM; record acceptance of 0.75, 1.25, 2.50 and 4.00 at M prompts.
- [ ] Fresh REVIEW; DESC; P ALL.
- Expected: four complete records; QTY displays whole numbers and PRICE displays two decimal places. Compare reloaded numbers, not just their entry screens.

### N02 - Ungrouped integer total

- [ ] Fresh REVIEW of NUM: TOT=QTY; P ALL; TOTAL; T.
- Expected: sum 10. Repeating TOTAL should show the same value without another tape pass or double accumulation.

### N03 - Ungrouped monetary total

- [ ] Fresh REVIEW: TOT=PRICE; P ALL; T.
- Expected: 8.50. Run independently from N02 because configuration resets differ.

### N04 - Grouped integer totals

- [ ] Fresh REVIEW: SORT=ZONE; TOT=QTY; P ALL; TOTAL.
- Expected group order and values:

| VALUE | COUNT | TOTAL |
|---|---:|---:|
| WEST | 2 | 6 |
| EAST | 1 | 3 |
| NORTH | 1 | 1 |

Grand total: 10. WEST's separated records must combine; the group order is not alphabetical.

### N05 - Grouped monetary totals and FLD

- [ ] Fresh REVIEW: SORT=ZONE; TOT=PRICE; FLD=ITEM; P ALL; T.
- Expected: listing shows ITEM only. Report still shows WEST/count 2/2.00, EAST/count 1/2.50, NORTH/count 1/4.00, grand total 8.50.
- Confirms decimal accumulation and that FLD does not suppress numeric accounting or direct report fields.

### N06 - Numeric EDIT persistence

- [ ] Fresh EDIT of NUM to im-num-edit.vbt; R; enter APPLE, WEST, 5, 3.50; EXIT; reload.
- Expected: only the first record changes; all remaining numeric and text fields survive. A fresh report should sum QTY to 13 and PRICE to 10.75.

## Pass 3: edges, limits and robustness

Run these after the ordinary workflows. Use disposable fixtures and separate output images. Do not mix several edge values in one unlogged entry attempt.

| ID | Experiment | What to record |
|---|---|---|
| X01 | During a disposable text record, try physical BACK/PREVIOUS, left/right controls available on the VideoBrain layout, character overwrite, insertion/deletion and SPECIAL after partial input. | Exact physical/PC key, before/after text, cursor, acceptance/cancellation and reload result. Do not assume PC Delete/arrows are mapped. |
| X02 | Separate numeric entry probes: I values 0, -2, +2, 12.5, blank; M values 0, -1.25, 2, 2.5, .75, 1.234, blank. Also compare I/6 values 99999 and 100000, and M/8 values 9999.99 and 10000.00. | Accepted/rejected spelling, displayed normalization, overflow/truncation, stored/reloaded value, whether NEXT or SPECIAL changes behavior. Use fresh records or separate tapes when a probe blocks entry. |
| X03 | Definition widths: A at 1, 8, 126, 127; I/M at 1, 15, 16; width 0; long names. | Acceptance/rejection, error/retry prompts, truncation, practical name/width limits. Large definitions may hit the overall workspace limit; distinguish that from an individual width rejection. |
| X04 | Increase field count and record width on disposable definitions. | Last accepted structure, first rejection, message and recovery. Do not assume per-field maxima can all fit in one record. |
| X05 | Fresh SORT/TOT fixture with 12 records: Z01..Z10 each QTY 1, then Z10/QTY 1 and Z01/QTY 1; use an A/8 ZONE field. | Predicted Z01 count/sum 2, Z02..Z09 count/sum 1 each, OTHER count/sum 2, grand total 12. Checks nine-key capacity and repeated overflow keys. |
| X06 | Separate grouping fixtures: blank/leading-space key, key width below 8, key width above 8 with identical first eight characters. | Whether keys collapse, adjacent-field bytes affect grouping, or reporting stops early. Keep a normal A/8 result for comparison. |
| X07 | On NUM, try SORT=QTY and TOT=ITEM, each in a fresh REVIEW; also unknown field names and missing equals signs. | Rejection and recovery; whether a prior setting is cleared. Do not continue a report assuming configuration survived an error. |
| X08 | EDIT after P ALL reaches end: A, then EXIT; separate run replacing a later current record; separate run with two additions. | EOF guard, current-record targeting, missing/duplicate/blank records and complete output reload. |
| X09 | MERGE three compatible inputs; separately merge a one-record input with the same layout but a different database name. | Repeated handoff, exact ordering, output header and final end marker. Do not use incompatible layouts for the normal test. |
| X10 | Review-only parser probes: PR ALL versus P ALL; PRI ALL; FLD ALL; FLD=ITEM in EDIT; PTR suffix in EDIT. | Exact acceptance/rejection and unchanged fixture. EDIT probes still need separate disposable output tapes. |

PTR syntax and physical printing are separate matters. The current core leaves printer TX unconnected, so do not count hard-copy testing as an available hardware task. If probing a PTR suffix anyway, use a separate REVIEW session, capture acceptance/hang/error, and make no claim about transmitted or printed data without observing the printer signal. No Record tape is needed.

Long stress cases are deferred from this manual session: per-group counts at 255/256 records and accumulation beyond the fourteen stored decimal digits. They need dedicated fixtures. Keep them marked unverified rather than extrapolating from the small report tests.

## Evidence and completion

For each case, keep the test ID, source/output filenames, exact commands and extra keys, expected versus actual record list, screen captures, cartridge errors, controller notices and whether reset was required. Preserve source fixtures and every anomalous VBT. A brief video is especially useful for ADD/SPECIAL, DELETE prompts and MERGE's pause.

Use PASS only when the stated checks are observed. Use FAIL for a completed check that differs, BLOCKED for a failed prerequisite and NOT RUN otherwise. Keep predictions and observations separate. Return the run log and tape files together so unexpected results can be compared against block lengths, repeated records and checksums before changing the manual.
