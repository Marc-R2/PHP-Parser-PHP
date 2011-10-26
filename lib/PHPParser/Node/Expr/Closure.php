<?php

/**
 * @property PHPParser_Node[]                 $stmts  Statements
 * @property PHPParser_Node_Stmt_FuncParam[]  $params Parameters
 * @property PHPParser_Node_Expr_ClosureUse[] $uses   use()s
 * @property bool                             $byRef  Whether to return by reference
 */
class PHPParser_Node_Expr_Closure extends PHPParser_Node_Expr
{
    /**
     * Constructs a lambda function node.
     *
     * @param PHPParser_Node[]                 $stmts      Statements
     * @param PHPParser_Node_Stmt_FuncParam[]  $params     Parameters
     * @param PHPParser_Node_Expr_ClosureUse[] $uses       use()s
     * @param bool                             $byRef      Whether to return by reference
     * @param int                              $line       Line
     * @param null|string                      $docComment Nearest doc comment
     */
    public function __construct(array $stmts, array $params = array(), array $uses = array(), $byRef = false, $line = -1, $docComment = null) {
        parent::__construct(
            array(
                'stmts'  => $stmts,
                'params' => $params,
                'uses'   => $uses,
                'byRef'  => $byRef
            ),
            $line, $docComment
        );
    }
}